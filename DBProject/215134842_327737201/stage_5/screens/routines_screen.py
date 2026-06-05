"""
Functions and Procedures screen – runs Stage 4 PL/pgSQL routines.
"""

from tkinter import messagebox

import customtkinter as ctk

import db
from screens.ui_theme import (
    ACCENT_BLUE,
    ACCENT_GREEN,
    ACCENT_ORANGE,
    FONT_BODY,
    FONT_SMALL,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    card,
    primary_button,
    section_title,
)


class RoutinesScreen(ctk.CTkFrame):
    """Screen to execute stored functions and procedures."""

    def __init__(self, parent, on_back=None, on_data_changed=None):
        super().__init__(parent, fg_color="transparent")
        self.on_back = on_back
        self.on_data_changed = on_data_changed
        self._build_ui()

    def _build_ui(self):
        header = section_title(
            self,
            "Functions & Procedures",
            "Execute Stage 4 PL/pgSQL routines",
        )
        header.pack(fill="x", pady=(0, 12))

        func_card = card(self)
        func_card.pack(fill="x", pady=(0, 12))
        ctk.CTkLabel(
            func_card,
            text="Functions (return a value)",
            font=("Segoe UI", 13, "bold"),
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w", padx=20, pady=(16, 8))

        func_inner = ctk.CTkFrame(func_card, fg_color="transparent")
        func_inner.pack(fill="x", padx=20, pady=(0, 8))

        self._add_routine_row(
            func_inner,
            0,
            "calculate_customer_marketing_score(p_customer_id)",
            "Customer ID:",
            self.run_customer_score,
            ACCENT_BLUE,
        )
        self._add_routine_row(
            func_inner,
            1,
            "calculate_employee_bonus(p_employee_id)",
            "Employee ID:",
            self.run_employee_bonus,
            ACCENT_GREEN,
        )

        self.func_result = ctk.CTkLabel(
            func_card,
            text="Function result will appear here.",
            font=FONT_BODY,
            text_color=TEXT_SECONDARY,
            wraplength=800,
            justify="left",
        )
        self.func_result.pack(anchor="w", padx=20, pady=(4, 16))

        proc_card = card(self)
        proc_card.pack(fill="x", pady=(0, 12))
        ctk.CTkLabel(
            proc_card,
            text="Procedures (modify data)",
            font=("Segoe UI", 13, "bold"),
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w", padx=20, pady=(16, 8))

        proc_inner = ctk.CTkFrame(proc_card, fg_color="transparent")
        proc_inner.pack(fill="x", padx=20, pady=(0, 8))

        self._procedure_row(
            proc_inner,
            0,
            "apply_campaign_discount(p_campaign_id)",
            "Campaign ID:",
            ACCENT_ORANGE,
        )
        self._procedure_row_restock(proc_inner, 1)

        self.proc_result = ctk.CTkLabel(
            proc_card,
            text="Procedure status will appear here.",
            font=FONT_BODY,
            text_color=TEXT_SECONDARY,
            wraplength=800,
            justify="left",
        )
        self.proc_result.pack(anchor="w", padx=20, pady=(4, 16))

        ctk.CTkLabel(
            self,
            text="After running procedures, sale and inventory data refresh automatically.",
            font=FONT_SMALL,
            text_color=TEXT_SECONDARY,
        ).pack(anchor="w", padx=4)

    def _add_routine_row(self, parent, row, title, label_text, command, color):
        row_frame = ctk.CTkFrame(parent, fg_color="#f8fafc", corner_radius=10)
        row_frame.pack(fill="x", pady=6)
        inner = ctk.CTkFrame(row_frame, fg_color="transparent")
        inner.pack(fill="x", padx=14, pady=12)

        ctk.CTkLabel(inner, text=title, font=FONT_BODY, text_color=TEXT_PRIMARY).pack(
            side="left", padx=(0, 16)
        )
        ctk.CTkLabel(inner, text=label_text, font=FONT_SMALL, text_color=TEXT_SECONDARY).pack(
            side="left"
        )
        entry = ctk.CTkEntry(inner, width=100, height=34, corner_radius=8)
        entry.pack(side="left", padx=8)
        primary_button(inner, "Run", lambda: command(entry), color, 80).pack(side="left", padx=4)

    def _procedure_row(self, parent, row, title, label_text, color):
        row_frame = ctk.CTkFrame(parent, fg_color="#f8fafc", corner_radius=10)
        row_frame.pack(fill="x", pady=6)
        inner = ctk.CTkFrame(row_frame, fg_color="transparent")
        inner.pack(fill="x", padx=14, pady=12)

        ctk.CTkLabel(inner, text=title, font=FONT_BODY, text_color=TEXT_PRIMARY).pack(
            side="left", padx=(0, 16)
        )
        ctk.CTkLabel(inner, text=label_text, font=FONT_SMALL, text_color=TEXT_SECONDARY).pack(
            side="left"
        )
        self.campaign_id_entry = ctk.CTkEntry(inner, width=100, height=34, corner_radius=8)
        self.campaign_id_entry.pack(side="left", padx=8)
        primary_button(inner, "Run", self.run_apply_discount, color, 80).pack(side="left", padx=4)

    def _procedure_row_restock(self, parent, row):
        row_frame = ctk.CTkFrame(parent, fg_color="#f8fafc", corner_radius=10)
        row_frame.pack(fill="x", pady=6)
        inner = ctk.CTkFrame(row_frame, fg_color="transparent")
        inner.pack(fill="x", padx=14, pady=12)

        ctk.CTkLabel(
            inner,
            text="restock_low_inventory(p_branch_id, p_extra_units)",
            font=FONT_BODY,
            text_color=TEXT_PRIMARY,
        ).pack(side="left", padx=(0, 12))
        ctk.CTkLabel(inner, text="Branch (empty=all):", font=FONT_SMALL, text_color=TEXT_SECONDARY).pack(
            side="left"
        )
        self.branch_id_entry = ctk.CTkEntry(inner, width=80, height=34, corner_radius=8)
        self.branch_id_entry.pack(side="left", padx=6)
        ctk.CTkLabel(inner, text="Extra units:", font=FONT_SMALL, text_color=TEXT_SECONDARY).pack(
            side="left"
        )
        self.extra_units_entry = ctk.CTkEntry(inner, width=60, height=34, corner_radius=8)
        self.extra_units_entry.insert(0, "20")
        self.extra_units_entry.pack(side="left", padx=6)
        primary_button(inner, "Run", self.run_restock, ACCENT_BLUE, 80).pack(side="left", padx=4)

    def run_customer_score(self, entry):
        customer_id = entry.get().strip()
        if not customer_id:
            messagebox.showwarning("Input Required", "Enter a customer ID.")
            return
        try:
            score = db.call_function("calculate_customer_marketing_score", (int(customer_id),))
            msg = f"Marketing score for customer {customer_id}: {score}"
            self.func_result.configure(text=msg)
            messagebox.showinfo("Success", msg)
        except Exception as exc:
            messagebox.showerror("Function Error", f"calculate_customer_marketing_score failed:\n{exc}")

    def run_employee_bonus(self, entry):
        employee_id = entry.get().strip()
        if not employee_id:
            messagebox.showwarning("Input Required", "Enter an employee ID.")
            return
        try:
            bonus = db.call_function("calculate_employee_bonus", (int(employee_id),))
            msg = f"Bonus for employee {employee_id}: {bonus}"
            self.func_result.configure(text=msg)
            messagebox.showinfo("Success", msg)
        except Exception as exc:
            messagebox.showerror("Function Error", f"calculate_employee_bonus failed:\n{exc}")

    def run_apply_discount(self):
        campaign_id = self.campaign_id_entry.get().strip()
        if not campaign_id:
            messagebox.showwarning("Input Required", "Enter a campaign ID.")
            return
        try:
            db.call_procedure("apply_campaign_discount", (int(campaign_id),))
            msg = f"Campaign discount applied for campaign {campaign_id}."
            self.proc_result.configure(text=msg)
            messagebox.showinfo("Success", msg)
            self._notify_data_changed()
        except Exception as exc:
            messagebox.showerror("Procedure Error", f"apply_campaign_discount failed:\n{exc}")

    def run_restock(self):
        branch_raw = self.branch_id_entry.get().strip()
        extra_raw = self.extra_units_entry.get().strip() or "20"
        try:
            branch_id = int(branch_raw) if branch_raw else None
            extra_units = int(extra_raw)
            db.call_procedure("restock_low_inventory", (branch_id, extra_units))
            branch_msg = branch_raw if branch_raw else "all branches"
            msg = f"Restock completed for {branch_msg} (+{extra_units} units above min level)."
            self.proc_result.configure(text=msg)
            messagebox.showinfo("Success", msg)
            self._notify_data_changed()
        except ValueError:
            messagebox.showwarning("Input Error", "Branch ID and extra units must be numbers.")
        except Exception as exc:
            messagebox.showerror("Procedure Error", f"restock_low_inventory failed:\n{exc}")

    def _notify_data_changed(self):
        if self.on_data_changed:
            self.on_data_changed()
