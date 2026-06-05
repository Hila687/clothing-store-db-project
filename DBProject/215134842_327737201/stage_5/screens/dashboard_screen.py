"""
Dashboard home page – summary cards, recent sales, quick actions.
"""

import tkinter as tk

import customtkinter as ctk

import db
from screens.ui_theme import (
    ACCENT_BLUE,
    ACCENT_GREEN,
    ACCENT_ORANGE,
    ACCENT_PURPLE,
    CARD_BG,
    FONT_BODY,
    FONT_SMALL,
    FONT_STAT,
    FONT_SUBHEADING,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    card,
    dynamic_treeview,
    primary_button,
    section_title,
)


class DashboardScreen(ctk.CTkFrame):
    """Modern dashboard with KPI cards and recent activity."""

    def __init__(self, parent, navigator):
        super().__init__(parent, fg_color="transparent")
        self.navigator = navigator
        self.stat_labels = {}
        self._build_ui()
        self.refresh_data()

    def _build_ui(self):
        scroll = ctk.CTkScrollableFrame(self, fg_color="transparent")
        scroll.pack(fill="both", expand=True)

        header = section_title(
            scroll,
            "Dashboard",
            "Overview of your clothing store management system",
        )
        header.pack(fill="x", padx=4, pady=(0, 16))

        # --- KPI cards ---
        cards_row = ctk.CTkFrame(scroll, fg_color="transparent")
        cards_row.pack(fill="x", pady=(0, 20))
        cards_row.grid_columnconfigure((0, 1, 2, 3), weight=1)

        self._stat_card(cards_row, 0, "Total Customers", "customers", ACCENT_BLUE, "👥")
        self._stat_card(cards_row, 1, "Total Products", "products", ACCENT_ORANGE, "📦")
        self._stat_card(cards_row, 2, "Total Sales", "sales", ACCENT_GREEN, "💰")
        self._stat_card(cards_row, 3, "Low Stock Items", "inventory", ACCENT_PURPLE, "📋")

        # --- Bottom row: recent sales + quick actions ---
        bottom = ctk.CTkFrame(scroll, fg_color="transparent")
        bottom.pack(fill="both", expand=True)
        bottom.grid_columnconfigure(0, weight=3)
        bottom.grid_columnconfigure(1, weight=1)

        # Recent sales
        sales_card = card(bottom)
        sales_card.grid(row=0, column=0, sticky="nsew", padx=(0, 10))
        sales_header = ctk.CTkFrame(sales_card, fg_color="transparent")
        sales_header.pack(fill="x", padx=20, pady=(16, 8))
        ctk.CTkLabel(
            sales_header, text="Recent Sales", font=FONT_SUBHEADING, text_color=TEXT_PRIMARY
        ).pack(side="left")
        ctk.CTkButton(
            sales_header,
            text="View all →",
            width=80,
            height=28,
            fg_color="transparent",
            hover_color="#f1f5f9",
            text_color=ACCENT_BLUE,
            command=lambda: self.navigator.show_screen("crud_sale"),
        ).pack(side="right")

        self.recent_tree, tree_wrap = dynamic_treeview(sales_card, height=8)
        tree_wrap.pack(fill="both", expand=True, padx=16, pady=(0, 16))

        # Quick actions
        actions_card = card(bottom)
        actions_card.grid(row=0, column=1, sticky="nsew")
        ctk.CTkLabel(
            actions_card,
            text="Quick Actions",
            font=FONT_SUBHEADING,
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w", padx=20, pady=(16, 12))

        actions_inner = ctk.CTkFrame(actions_card, fg_color="transparent")
        actions_inner.pack(fill="both", expand=True, padx=16, pady=(0, 16))

        self._quick_action(
            actions_inner,
            "Add Customer",
            ACCENT_BLUE,
            lambda: self.navigator.show_screen("crud_customer"),
        )
        self._quick_action(
            actions_inner,
            "Add Product",
            ACCENT_ORANGE,
            lambda: self.navigator.show_screen("crud_product"),
        )
        self._quick_action(
            actions_inner,
            "New Sale",
            ACCENT_GREEN,
            lambda: self.navigator.show_screen("crud_sale"),
        )
        self._quick_action(
            actions_inner,
            "View Reports",
            ACCENT_PURPLE,
            lambda: self.navigator.show_screen("queries"),
        )

    def _stat_card(self, parent, col, title, key, accent, icon):
        frame = card(parent)
        frame.grid(row=0, column=col, sticky="nsew", padx=6)

        top = ctk.CTkFrame(frame, fg_color="transparent")
        top.pack(fill="x", padx=20, pady=(18, 4))
        icon_box = ctk.CTkFrame(top, width=40, height=40, corner_radius=10, fg_color=accent)
        icon_box.pack(side="left")
        icon_box.pack_propagate(False)
        ctk.CTkLabel(icon_box, text=icon, font=(FONT_BODY[0], 18)).place(relx=0.5, rely=0.5, anchor="center")
        ctk.CTkLabel(top, text=title, font=FONT_SMALL, text_color=TEXT_SECONDARY).pack(
            side="left", padx=(12, 0)
        )

        value_label = ctk.CTkLabel(frame, text="—", font=FONT_STAT, text_color=TEXT_PRIMARY)
        value_label.pack(anchor="w", padx=20, pady=(0, 18))
        self.stat_labels[key] = value_label

    def _quick_action(self, parent, label, color, command):
        row = ctk.CTkFrame(parent, fg_color="#f8fafc", corner_radius=12, height=72)
        row.pack(fill="x", pady=6)
        row.pack_propagate(False)
        btn = ctk.CTkButton(
            row,
            text="+",
            width=44,
            height=44,
            corner_radius=12,
            fg_color=color,
            hover_color=color,
            font=(FONT_BODY[0], 20, "bold"),
            command=command,
        )
        btn.pack(side="left", padx=14, pady=14)
        ctk.CTkLabel(row, text=label, font=FONT_BODY, text_color=TEXT_PRIMARY).pack(
            side="left", padx=4
        )

    def refresh_data(self):
        """Load dashboard statistics from the database."""
        try:
            cust = db.fetch_one("SELECT COUNT(*) FROM customer")
            prod = db.fetch_one("SELECT COUNT(*) FROM product")
            sales = db.fetch_one("SELECT COALESCE(SUM(total_amount), 0) FROM sale")
            low = db.fetch_one(
                """
                SELECT COUNT(*) FROM inventory
                WHERE COALESCE(quantity_in_stock, 0) < COALESCE(min_stock_level, 0)
                """
            )

            self.stat_labels["customers"].configure(text=str(cust[0]))
            self.stat_labels["products"].configure(text=str(prod[0]))
            self.stat_labels["sales"].configure(text=f"${float(sales[0]):,.2f}")
            self.stat_labels["inventory"].configure(text=str(low[0]))

            self._load_recent_sales()
        except Exception:
            for label in self.stat_labels.values():
                label.configure(text="N/A")

    def _load_recent_sales(self):
        cols = ("sale_id", "receipt_number", "sale_date", "total_amount", "sale_status")
        headings = ("ID", "Receipt", "Date", "Amount", "Status")
        self.recent_tree["columns"] = cols
        for c, h in zip(cols, headings):
            self.recent_tree.heading(c, text=h)
            self.recent_tree.column(c, width=100)

        for item in self.recent_tree.get_children():
            self.recent_tree.delete(item)

        _, rows = db.fetch_all(
            """
            SELECT sale_id, receipt_number, sale_date, total_amount, sale_status
            FROM sale
            ORDER BY sale_date DESC NULLS LAST, sale_id DESC
            LIMIT 8
            """
        )
        for row in rows:
            display = []
            for i, val in enumerate(row):
                if val is None:
                    display.append("")
                elif hasattr(val, "isoformat"):
                    display.append(val.isoformat())
                elif i == 3:
                    display.append(f"${float(val):,.2f}")
                else:
                    display.append(str(val))
            self.recent_tree.insert("", tk.END, values=display)
