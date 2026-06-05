"""
Reports / Queries screen – runs selected queries from Queries.sql.
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
    FONT_SMALL,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    card,
    dynamic_treeview,
    primary_button,
    section_title,
)

QUERIES = {
    "query1": {
        "title": "Query 1: Sales Summary per Branch (Date Range)",
        "description": "Sales count and total amount per branch between two dates.",
        "needs_dates": True,
        "sql": """
            SELECT
                b.branch_id,
                b.branch_name,
                COUNT(s.sale_id) AS number_of_sales,
                SUM(s.total_amount) AS total_sales_amount
            FROM branch b
            JOIN sale s ON b.branch_id = s.branch_id
            WHERE s.sale_date BETWEEN %s AND %s
            GROUP BY b.branch_id, b.branch_name
            ORDER BY total_sales_amount DESC
        """,
    },
    "query2": {
        "title": "Query 2: Best-Selling Products by Quantity",
        "description": "Products ranked by total quantity sold.",
        "needs_dates": False,
        "sql": """
            SELECT
                p.product_id,
                p.product_name,
                p.brand,
                SUM(si.quantity) AS total_quantity_sold
            FROM product p
            JOIN inventory i ON p.product_id = i.product_id
            JOIN sale_inventory si ON i.inventory_id = si.inventory_id
            GROUP BY p.product_id, p.product_name, p.brand
            ORDER BY total_quantity_sold DESC
        """,
    },
    "query5": {
        "title": "Query 5: Low Inventory Report for Goods Order",
        "description": "Products below minimum stock level per branch.",
        "needs_dates": False,
        "sql": """
            SELECT
                p.product_name,
                i.quantity_in_stock,
                i.min_stock_level,
                b.branch_name
            FROM inventory i
            JOIN product p ON i.product_id = p.product_id
            JOIN branch b ON i.branch_id = b.branch_id
            WHERE i.quantity_in_stock < i.min_stock_level
            ORDER BY i.quantity_in_stock ASC
        """,
    },
}


class QueriesScreen(ctk.CTkFrame):
    """Screen to run predefined SQL reports."""

    def __init__(self, parent, on_back=None):
        super().__init__(parent, fg_color="transparent")
        self.on_back = on_back
        self._build_ui()

    def _build_ui(self):
        header = section_title(
            self,
            "Reports / Queries",
            "Run predefined SQL reports from Queries.sql",
        )
        header.pack(fill="x", pady=(0, 12))

        params_card = card(self)
        params_card.pack(fill="x", pady=(0, 12))
        params_inner = ctk.CTkFrame(params_card, fg_color="transparent")
        params_inner.pack(fill="x", padx=20, pady=16)

        ctk.CTkLabel(
            params_inner,
            text="Date Range (Query 1)",
            font=("Segoe UI", 13, "bold"),
            text_color=TEXT_PRIMARY,
        ).grid(row=0, column=0, columnspan=4, sticky="w", pady=(0, 8))

        ctk.CTkLabel(params_inner, text="From:", font=FONT_SMALL, text_color=TEXT_SECONDARY).grid(
            row=1, column=0, padx=(0, 6)
        )
        self.date_from = ctk.CTkEntry(params_inner, width=140, height=34, corner_radius=8)
        self.date_from.insert(0, "2024-01-01")
        self.date_from.grid(row=1, column=1, padx=(0, 16))

        ctk.CTkLabel(params_inner, text="To:", font=FONT_SMALL, text_color=TEXT_SECONDARY).grid(
            row=1, column=2, padx=(0, 6)
        )
        self.date_to = ctk.CTkEntry(params_inner, width=140, height=34, corner_radius=8)
        self.date_to.insert(0, "2024-12-31")
        self.date_to.grid(row=1, column=3)

        btn_card = card(self)
        btn_card.pack(fill="x", pady=(0, 12))
        btn_inner = ctk.CTkFrame(btn_card, fg_color="transparent")
        btn_inner.pack(fill="x", padx=16, pady=14)

        primary_button(
            btn_inner, "Query 1 – Sales by Branch", lambda: self.run_query("query1"), ACCENT_BLUE, 200
        ).pack(side="left", padx=6)
        primary_button(
            btn_inner, "Query 2 – Best Sellers", lambda: self.run_query("query2"), ACCENT_ORANGE, 180
        ).pack(side="left", padx=6)
        primary_button(
            btn_inner, "Query 5 – Low Inventory", lambda: self.run_query("query5"), ACCENT_GREEN, 190
        ).pack(side="left", padx=6)

        result_card = card(self)
        result_card.pack(fill="both", expand=True)

        self.result_label = ctk.CTkLabel(
            result_card,
            text="Select a query to run.",
            font=FONT_BODY,
            text_color=TEXT_SECONDARY,
        )
        self.result_label.pack(anchor="w", padx=20, pady=(16, 8))

        self.tree, tree_wrap = dynamic_treeview(result_card, height=16)
        tree_wrap.pack(fill="both", expand=True, padx=16, pady=(0, 16))

    def run_query(self, query_key):
        q = QUERIES[query_key]
        try:
            if q["needs_dates"]:
                params = (self.date_from.get().strip(), self.date_to.get().strip())
                columns, rows = db.fetch_all(q["sql"], params)
            else:
                columns, rows = db.fetch_all(q["sql"])

            self._show_results(q["title"], columns, rows)
            messagebox.showinfo("Success", f"{q['title']}\nReturned {len(rows)} row(s).")
        except Exception as exc:
            messagebox.showerror("Query Error", f"Failed to run query:\n{exc}")

    def _show_results(self, title, columns, rows):
        self.result_label.configure(text=title)

        for col in self.tree["columns"]:
            self.tree.heading(col, text="")
        self.tree["columns"] = columns
        for col in columns:
            self.tree.heading(col, text=col)
            self.tree.column(col, width=120, minwidth=80)

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
