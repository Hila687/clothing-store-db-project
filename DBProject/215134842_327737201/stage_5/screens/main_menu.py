"""Main menu screen with navigation buttons."""

import tkinter as tk
from tkinter import ttk


class MainMenuScreen(ttk.Frame):
    """Home screen – buttons navigate to CRUD, queries, views, and routines."""

    def __init__(self, parent, navigator):
        super().__init__(parent)
        self.navigator = navigator
        self._build_ui()

    def _build_ui(self):
        ttk.Label(
            self,
            text="Clothing Store Database",
            font=("Segoe UI", 18, "bold"),
        ).pack(pady=(30, 5))
        ttk.Label(
            self,
            text="Stage 5 – PostgreSQL GUI Application",
            font=("Segoe UI", 11),
        ).pack(pady=(0, 25))

        sections = [
            ("CRUD Management", [
                ("Customers", "crud_customer"),
                ("Products", "crud_product"),
                ("Sales", "crud_sale"),
                ("Inventory", "crud_inventory"),
            ]),
            ("Reports & Analysis", [
                ("Reports / Queries", "queries"),
                ("Database Views", "views"),
                ("Functions & Procedures", "routines"),
            ]),
        ]

        for section_title, buttons in sections:
            frame = ttk.LabelFrame(self, text=section_title, padding=15)
            frame.pack(fill="x", padx=40, pady=8)
            for label, screen_id in buttons:
                ttk.Button(
                    frame,
                    text=label,
                    command=lambda sid=screen_id: self.navigator.show_screen(sid),
                    width=28,
                ).pack(pady=4)

        ttk.Label(
            self,
            text="Configure connection in config.py before running.",
            font=("Segoe UI", 9),
            foreground="gray",
        ).pack(pady=20)
