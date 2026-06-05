"""
Reusable CRUD screen – list, add, update (select row), delete, refresh.
Business logic unchanged; UX-focused layout and workflow.
"""

import json
import tkinter as tk
from tkinter import messagebox

import customtkinter as ctk

import db
from screens.crud_config import TABLE_CONFIGS
from screens.ui_theme import (
    ACCENT_BLUE,
    ACCENT_GREEN,
    ACCENT_RED,
    FONT_BODY,
    FONT_SMALL,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    card,
    crud_treeview,
    danger_button,
    populate_tree_rows,
    primary_button,
    secondary_button,
)


class CrudScreen(ctk.CTkFrame):
    """Generic CRUD frame driven by TABLE_CONFIGS."""

    HELP_TEXT = (
        "To update or delete a record, first select it from the table. "
        "To add a new record, fill the form below and click Add Record."
    )

    def __init__(self, parent, table_key, on_back=None):
        super().__init__(parent, fg_color="transparent")
        self.table_key = table_key
        self.config_data = TABLE_CONFIGS[table_key]
        self.on_back = on_back
        self.field_widgets = {}
        self.fk_maps = {}
        self._all_rows = []
        self.selected_pk = None

        self._build_ui()
        self.refresh_data()

    def _build_ui(self):
        cfg = self.config_data

        scroll = ctk.CTkScrollableFrame(self, fg_color="transparent")
        scroll.pack(fill="both", expand=True)

        # --- 1. Header ---
        header_card = card(scroll)
        header_card.pack(fill="x", pady=(0, 10))
        header_inner = ctk.CTkFrame(header_card, fg_color="transparent")
        header_inner.pack(fill="x", padx=20, pady=16)

        ctk.CTkLabel(
            header_inner,
            text=cfg["title"],
            font=("Segoe UI", 18, "bold"),
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w")
        ctk.CTkLabel(
            header_inner,
            text=self.HELP_TEXT,
            font=FONT_SMALL,
            text_color=TEXT_SECONDARY,
            wraplength=900,
            justify="left",
        ).pack(anchor="w", pady=(6, 0))

        self.status_label = ctk.CTkLabel(
            header_inner,
            text="No record selected",
            font=FONT_BODY,
            text_color=ACCENT_BLUE,
        )
        self.status_label.pack(anchor="w", pady=(8, 0))

        # --- 2. Search ---
        search_card = card(scroll)
        search_card.pack(fill="x", pady=(0, 10))
        search_inner = ctk.CTkFrame(search_card, fg_color="transparent")
        search_inner.pack(fill="x", padx=20, pady=14)

        ctk.CTkLabel(
            search_inner,
            text="Search & Filter",
            font=("Segoe UI", 13, "bold"),
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w", pady=(0, 8))

        search_row = ctk.CTkFrame(search_inner, fg_color="transparent")
        search_row.pack(fill="x")
        ctk.CTkLabel(search_row, text="Search records:", font=FONT_BODY, text_color=TEXT_SECONDARY).pack(
            side="left", padx=(0, 10)
        )
        self.search_entry = ctk.CTkEntry(
            search_row,
            placeholder_text="Type to filter the table…",
            width=360,
            height=36,
            corner_radius=10,
        )
        self.search_entry.pack(side="left")
        self.search_entry.bind("<KeyRelease>", lambda _e: self._apply_search())
        secondary_button(search_row, "Clear Search", self._clear_search, 110).pack(side="left", padx=10)

        # --- 3. Records table ---
        table_card = card(scroll)
        table_card.pack(fill="x", pady=(0, 10))

        table_header = ctk.CTkFrame(table_card, fg_color="transparent")
        table_header.pack(fill="x", padx=20, pady=(16, 6))
        ctk.CTkLabel(
            table_header,
            text="Records",
            font=("Segoe UI", 13, "bold"),
            text_color=TEXT_PRIMARY,
        ).pack(side="left")
        secondary_button(table_header, "Refresh", self.refresh_data, 90).pack(side="right")

        ctk.CTkLabel(
            table_card,
            text="Select a row to edit or delete — the form below will fill automatically.",
            font=FONT_SMALL,
            text_color=TEXT_SECONDARY,
        ).pack(anchor="w", padx=20, pady=(0, 8))

        col_ids = [c[0] for c in cfg["list_columns"]]
        col_labels = [c[1] for c in cfg["list_columns"]]
        self.tree, tree_wrap = crud_treeview(table_card, col_ids, col_labels, height=7)
        tree_wrap.pack(fill="x", padx=16, pady=(0, 16))
        self.tree.bind("<<TreeviewSelect>>", self._on_tree_select)

        # --- 4. Form + 5. Action buttons ---
        form_card = card(scroll)
        form_card.pack(fill="x", pady=(0, 8))

        form_header = ctk.CTkFrame(form_card, fg_color="transparent")
        form_header.pack(fill="x", padx=20, pady=(16, 4))
        ctk.CTkLabel(
            form_header,
            text="Add / Edit Record",
            font=("Segoe UI", 14, "bold"),
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w")
        self.form_hint = ctk.CTkLabel(
            form_header,
            text="Fill the form and click Add Record to create a new entry.",
            font=FONT_SMALL,
            text_color=TEXT_SECONDARY,
        )
        self.form_hint.pack(anchor="w", pady=(4, 0))

        form_body = ctk.CTkFrame(form_card, fg_color="transparent")
        form_body.pack(fill="x", padx=20, pady=(8, 0))
        form_body.grid_columnconfigure(0, weight=1)
        form_body.grid_columnconfigure(1, weight=1)

        fields = cfg["fields"]
        mid = (len(fields) + 1) // 2
        left_fields = fields[:mid]
        right_fields = fields[mid:]

        left_col = ctk.CTkFrame(form_body, fg_color="transparent")
        left_col.grid(row=0, column=0, sticky="nsew", padx=(0, 12))
        right_col = ctk.CTkFrame(form_body, fg_color="transparent")
        right_col.grid(row=0, column=1, sticky="nsew", padx=(12, 0))

        for col_frame, field_list in ((left_col, left_fields), (right_col, right_fields)):
            col_frame.grid_columnconfigure(1, weight=1)
            for row_idx, field in enumerate(field_list):
                self._add_form_field(col_frame, field, row_idx)

        # Action buttons (near form)
        actions_card = ctk.CTkFrame(form_card, fg_color="#f8fafc", corner_radius=10)
        actions_card.pack(fill="x", padx=20, pady=(16, 20))

        actions_inner = ctk.CTkFrame(actions_card, fg_color="transparent")
        actions_inner.pack(padx=16, pady=14)

        ctk.CTkLabel(
            actions_inner,
            text="Actions",
            font=("Segoe UI", 12, "bold"),
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w", pady=(0, 10))

        btn_row = ctk.CTkFrame(actions_inner, fg_color="transparent")
        btn_row.pack(fill="x")

        primary_button(btn_row, "Add Record", self.add_record, ACCENT_GREEN, 130).pack(
            side="left", padx=(0, 8)
        )
        primary_button(btn_row, "Save Changes", self.save_update, ACCENT_BLUE, 130).pack(
            side="left", padx=8
        )
        danger_button(btn_row, "Delete Selected", self.delete_record, 130).pack(side="left", padx=8)
        secondary_button(btn_row, "Clear Form", self.clear_form, 110).pack(side="left", padx=8)
        secondary_button(btn_row, "Refresh", self.refresh_data, 90).pack(side="left", padx=8)

    def _add_form_field(self, parent, field, row):
        label_text = field["label"]
        if field.get("required"):
            label_text += " *"

        lbl = ctk.CTkLabel(
            parent,
            text=label_text + ":",
            font=FONT_SMALL,
            text_color=ACCENT_RED if field.get("required") else TEXT_SECONDARY,
        )
        lbl.grid(row=row, column=0, sticky="e", padx=(0, 10), pady=7)

        widget = self._create_field_widget(parent, field)
        widget.grid(row=row, column=1, sticky="ew", pady=7)
        self.field_widgets[field["name"]] = (field, widget)

    def _create_field_widget(self, parent, field):
        ftype = field["type"]
        if ftype == "fk":
            lookup_display = field["lookup_display"]
            query = (
                f"SELECT {field['lookup_id']}, {lookup_display} "
                f"FROM {field['lookup_table']} ORDER BY {lookup_display}"
            )
            _, rows = db.fetch_all(query)
            display_values = []
            id_map = {}
            for row in rows:
                fk_id, display = row[0], str(row[1])
                display_values.append(display)
                id_map[display] = fk_id
            combo = ctk.CTkComboBox(
                parent,
                values=[""] + display_values,
                height=36,
                corner_radius=8,
                dropdown_font=FONT_BODY,
                font=FONT_BODY,
                width=280,
            )
            combo.set("")
            self.fk_maps[field["name"]] = id_map
            return combo
        return ctk.CTkEntry(parent, height=36, corner_radius=8, font=FONT_BODY, width=280)

    def _update_selection_ui(self):
        cfg = self.config_data
        pk_name = cfg["pk"]
        if self.selected_pk:
            self.status_label.configure(
                text=f"Selected: {pk_name} = {self.selected_pk}",
                text_color=ACCENT_BLUE,
            )
            self.form_hint.configure(
                text=f"Editing record {self.selected_pk}. Change fields and click Save Changes."
            )
        else:
            self.status_label.configure(text="No record selected", text_color=TEXT_SECONDARY)
            self.form_hint.configure(
                text="Fill the form and click Add Record to create a new entry."
            )

    def _on_tree_select(self, _event):
        selected = self.tree.selection()
        if not selected:
            return
        values = self.tree.item(selected[0], "values")
        if not values:
            return
        pk = str(values[0])
        self.selected_pk = pk
        self._load_record_into_form(pk)
        self._update_selection_ui()

    def _load_record_into_form(self, pk):
        """Load full row from DB into form fields (same logic as before, no popup)."""
        try:
            row = db.fetch_one(self.config_data["load_query"], (pk,))
            if row is None:
                return
            col_names_query = """
                SELECT column_name FROM information_schema.columns
                WHERE table_name = %s AND table_schema = 'public'
                ORDER BY ordinal_position
            """
            _, col_rows = db.fetch_all(col_names_query, (self.config_data["table"],))
            all_cols = [r[0] for r in col_rows]
            row_dict = dict(zip(all_cols, row))
            self._set_field_values(row_dict)
        except Exception as exc:
            messagebox.showerror("Database Error", f"Failed to load record:\n{exc}")

    def _clear_search(self):
        self.search_entry.delete(0, tk.END)
        self._apply_search()

    def _apply_search(self):
        term = self.search_entry.get().strip().lower()
        filtered = []
        for row in self._all_rows:
            if not term or any(term in str(v).lower() for v in row):
                filtered.append(row)
        populate_tree_rows(self.tree, filtered)

    def refresh_data(self):
        cfg = self.config_data
        try:
            _, rows = db.fetch_all(cfg["list_query"])
            self._all_rows = []
            for row in rows:
                display_row = []
                for val in row:
                    if val is None:
                        display_row.append("")
                    elif hasattr(val, "isoformat"):
                        display_row.append(val.isoformat())
                    else:
                        display_row.append(str(val))
                self._all_rows.append(tuple(display_row))
            self._apply_search()
        except Exception as exc:
            messagebox.showerror("Database Error", f"Failed to load records:\n{exc}")

    def _get_field_values(self, for_insert=False):
        """Read form widgets and return dict of column -> value."""
        values = {}
        for name, (field, widget) in self.field_widgets.items():
            ftype = field["type"]
            if ftype == "fk":
                display = widget.get().strip()
                if not display:
                    values[name] = None
                else:
                    values[name] = self.fk_maps[name].get(display)
            else:
                raw = widget.get().strip()
                if not raw:
                    values[name] = None
                    continue
                if ftype == "int":
                    values[name] = int(raw)
                elif ftype == "decimal":
                    values[name] = float(raw)
                elif ftype == "date":
                    values[name] = raw
                elif ftype == "json":
                    values[name] = raw
                else:
                    values[name] = raw

            if field.get("required") and values.get(name) in (None, ""):
                raise ValueError(f"{field['label']} is required.")

        return values

    def _set_field_values(self, row_dict):
        """Populate form from a loaded row dictionary."""
        for name, (field, widget) in self.field_widgets.items():
            val = row_dict.get(name)
            if field["type"] == "fk":
                widget.set("")
                if val is not None:
                    id_map = self.fk_maps[name]
                    for display, fk_id in id_map.items():
                        if fk_id == val:
                            widget.set(display)
                            break
            else:
                widget.delete(0, tk.END)
                if val is not None:
                    if hasattr(val, "isoformat"):
                        widget.insert(0, val.isoformat())
                    elif isinstance(val, dict):
                        widget.insert(0, json.dumps(val))
                    else:
                        widget.insert(0, str(val))

    def clear_form(self):
        self.selected_pk = None
        for item in self.tree.selection():
            self.tree.selection_remove(item)
        for _name, (field, widget) in self.field_widgets.items():
            if field["type"] == "fk":
                widget.set("")
            else:
                widget.delete(0, tk.END)
        self._update_selection_ui()

    def add_record(self):
        cfg = self.config_data
        try:
            values = self._get_field_values(for_insert=True)
            cols = list(values.keys())
            col_names = ", ".join(cols)
            placeholders = []
            params = []
            for col in cols:
                val = values[col]
                field_def = next(f for f in cfg["fields"] if f["name"] == col)
                if field_def["type"] == "json" and val is not None:
                    placeholders.append("%s::json")
                else:
                    placeholders.append("%s")
                params.append(val)
            query = (
                f"INSERT INTO {cfg['table']} ({col_names}) "
                f"VALUES ({', '.join(placeholders)}) RETURNING {cfg['pk']}"
            )
            new_id = db.execute_write_returning(query, tuple(params))
            messagebox.showinfo("Success", f"Record added. {cfg['pk']} = {new_id[0]}")
            self.clear_form()
            self.refresh_data()
        except ValueError as exc:
            messagebox.showwarning("Validation Error", str(exc))
        except Exception as exc:
            messagebox.showerror("Database Error", f"Insert failed:\n{exc}")

    def save_update(self):
        cfg = self.config_data
        if not self.selected_pk:
            messagebox.showinfo(
                "No Record Selected",
                "Please select a row from the table first, then edit the form and click Save Changes.",
            )
            return
        pk = self.selected_pk
        try:
            values = self._get_field_values()
            set_parts = []
            params = []
            for col, val in values.items():
                field_def = next(f for f in cfg["fields"] if f["name"] == col)
                if field_def["type"] == "json" and val is not None:
                    set_parts.append(f"{col} = %s::json")
                else:
                    set_parts.append(f"{col} = %s")
                params.append(val)
            params.append(pk)
            query = (
                f"UPDATE {cfg['table']} SET {', '.join(set_parts)} "
                f"WHERE {cfg['pk']} = %s"
            )
            count = db.execute_write(query, tuple(params))
            if count == 0:
                messagebox.showwarning("Not Found", f"No record with {cfg['pk']} = {pk}.")
            else:
                messagebox.showinfo("Success", f"Record {pk} updated successfully.")
                self.refresh_data()
                self._load_record_into_form(pk)
        except ValueError as exc:
            messagebox.showwarning("Validation Error", str(exc))
        except Exception as exc:
            messagebox.showerror("Database Error", f"Update failed:\n{exc}")

    def delete_record(self):
        cfg = self.config_data
        if not self.selected_pk:
            messagebox.showinfo(
                "No Record Selected",
                "Please select a row from the table first, then click Delete Selected.",
            )
            return
        pk = self.selected_pk
        if not messagebox.askyesno(
            "Confirm Delete",
            f"Are you sure you want to delete this record?\n\n{cfg['pk']} = {pk}",
        ):
            return
        try:
            query = f"DELETE FROM {cfg['table']} WHERE {cfg['pk']} = %s"
            count = db.execute_write(query, (pk,))
            if count == 0:
                messagebox.showwarning("Not Found", f"No record with {cfg['pk']} = {pk}.")
            else:
                messagebox.showinfo("Success", f"Record {pk} deleted.")
                self.clear_form()
                self.refresh_data()
        except Exception as exc:
            messagebox.showerror("Database Error", f"Delete failed:\n{exc}")
