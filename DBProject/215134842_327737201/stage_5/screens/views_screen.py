"""
Database Views screen – displays views from Views.sql.
"""

import tkinter as tk
from tkinter import messagebox

import customtkinter as ctk

import db
from screens.ui_theme import (
    ACCENT_BLUE,
    ACCENT_GREEN,
    ACCENT_ORANGE,
    FONT_BODY,
    TEXT_SECONDARY,
    card,
    dynamic_treeview,
    primary_button,
    section_title,
)

VIEWS = {
    "v_clothing_store_summary": {
        "title": "v_clothing_store_summary",
        "description": "Customer purchases and spending per branch.",
    },
    "v_campaign_reach_summary": {
        "title": "v_campaign_reach_summary",
        "description": "Campaign budget and targeted customer counts.",
    },
    "v_integrated_marketing_sales": {
        "title": "v_integrated_marketing_sales",
        "description": "Campaign reach vs actual sales integration.",
    },
}


class ViewsScreen(ctk.CTkFrame):
    """Screen to browse predefined database views."""

    def __init__(self, parent, on_back=None):
        super().__init__(parent, fg_color="transparent")
        self.on_back = on_back
        self._build_ui()

    def _build_ui(self):
        header = section_title(
            self,
            "Database Views",
            "Browse integrated views from Views.sql",
        )
        header.pack(fill="x", pady=(0, 12))

        btn_card = card(self)
        btn_card.pack(fill="x", pady=(0, 12))
        btn_inner = ctk.CTkFrame(btn_card, fg_color="transparent")
        btn_inner.pack(fill="x", padx=16, pady=14)

        colors = [ACCENT_BLUE, ACCENT_ORANGE, ACCENT_GREEN]
        for i, (view_name, info) in enumerate(VIEWS.items()):
            primary_button(
                btn_inner,
                info["title"],
                lambda v=view_name: self.show_view(v),
                colors[i % len(colors)],
                240,
            ).pack(side="left", padx=6)

        result_card = card(self)
        result_card.pack(fill="both", expand=True)

        self.result_label = ctk.CTkLabel(
            result_card,
            text="Select a view to display.",
            font=FONT_BODY,
            text_color=TEXT_SECONDARY,
        )
        self.result_label.pack(anchor="w", padx=20, pady=(16, 8))

        self.tree, tree_wrap = dynamic_treeview(result_card, height=18)
        tree_wrap.pack(fill="both", expand=True, padx=16, pady=(0, 16))

    def show_view(self, view_name):
        info = VIEWS[view_name]
        try:
            columns, rows = db.fetch_all(f"SELECT * FROM {view_name}")
            self.result_label.configure(text=f"{info['title']} – {info['description']}")

            for col in self.tree["columns"]:
                self.tree.heading(col, text="")
            self.tree["columns"] = columns
            for col in columns:
                self.tree.heading(col, text=col)
                self.tree.column(col, width=130, minwidth=80)

            for item in self.tree.get_children():
                self.tree.delete(item)

            for row in rows:
                display = []
                for val in row:
                    if val is None:
                        display.append("")
                    elif hasattr(val, "isoformat"):
                        display.append(val.isoformat())
                    else:
                        display.append(str(val))
                self.tree.insert("", tk.END, values=display)

            messagebox.showinfo("Success", f"{view_name}: {len(rows)} row(s) loaded.")
        except Exception as exc:
            messagebox.showerror("View Error", f"Failed to load view {view_name}:\n{exc}")
