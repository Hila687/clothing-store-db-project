"""
Clothing Store Database – Stage 5 GUI Application
Modern CustomTkinter shell with sidebar navigation.
"""

from tkinter import messagebox

import customtkinter as ctk

from screens.crud_screen import CrudScreen
from screens.dashboard_screen import DashboardScreen
from screens.queries_screen import QueriesScreen
from screens.routines_screen import RoutinesScreen
from screens.ui_theme import (
    CONTENT_BG,
    FONT_BODY,
    FONT_HEADING,
    FONT_SMALL,
    SIDEBAR_ACTIVE,
    SIDEBAR_BG,
    SIDEBAR_HOVER,
    SIDEBAR_MUTED,
    SIDEBAR_TEXT,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    configure_app_theme,
)
from screens.views_screen import ViewsScreen

# Sidebar navigation items: (label, screen_id, icon)
NAV_ITEMS = [
    ("Dashboard", "dashboard", "▦"),
    ("Customers", "crud_customer", "👤"),
    ("Products", "crud_product", "👕"),
    ("Sales", "crud_sale", "🛒"),
    ("Inventory", "crud_inventory", "📦"),
    ("Reports", "queries", "📊"),
    ("Views", "views", "👁"),
    ("Functions & Procedures", "routines", "⚙"),
]

PAGE_TITLES = {
    "dashboard": "Dashboard",
    "crud_customer": "Customer Management",
    "crud_product": "Product Management",
    "crud_sale": "Sale Management",
    "crud_inventory": "Inventory Management",
    "queries": "Reports / Queries",
    "views": "Database Views",
    "routines": "Functions & Procedures",
}


class App(ctk.CTk):
    """Main application with sidebar, header, and content area."""

    def __init__(self):
        configure_app_theme()
        super().__init__()
        self.title("ThreadFlow – Clothing Store Management")
        self.geometry("1280x800")
        self.minsize(1024, 680)
        self.configure(fg_color=CONTENT_BG)

        self.current_screen = None
        self.nav_buttons = {}
        self.screens = {}

        self._build_layout()
        self._build_screens()
        self.show_screen("dashboard")
        self.after(100, self._test_connection)

    def _build_layout(self):
        self.grid_columnconfigure(1, weight=1)
        self.grid_rowconfigure(0, weight=1)

        # --- Sidebar ---
        self.sidebar = ctk.CTkFrame(self, width=240, corner_radius=0, fg_color=SIDEBAR_BG)
        self.sidebar.grid(row=0, column=0, sticky="nsew")
        self.sidebar.grid_propagate(False)

        brand = ctk.CTkFrame(self.sidebar, fg_color="transparent")
        brand.pack(fill="x", padx=20, pady=(24, 28))
        logo = ctk.CTkFrame(brand, width=36, height=36, corner_radius=10, fg_color=SIDEBAR_ACTIVE)
        logo.pack(side="left")
        logo.pack_propagate(False)
        ctk.CTkLabel(logo, text="T", font=("Segoe UI", 18, "bold"), text_color="#ffffff").place(
            relx=0.5, rely=0.5, anchor="center"
        )
        ctk.CTkLabel(
            brand, text="ThreadFlow", font=("Segoe UI", 18, "bold"), text_color="#ffffff"
        ).pack(side="left", padx=(10, 0))

        nav_wrap = ctk.CTkFrame(self.sidebar, fg_color="transparent")
        nav_wrap.pack(fill="both", expand=True, padx=12)

        for label, screen_id, icon in NAV_ITEMS:
            btn = ctk.CTkButton(
                nav_wrap,
                text=f"  {icon}  {label}",
                anchor="w",
                height=42,
                corner_radius=10,
                fg_color="transparent",
                hover_color=SIDEBAR_HOVER,
                text_color=SIDEBAR_TEXT,
                font=FONT_BODY,
                command=lambda sid=screen_id: self.show_screen(sid),
            )
            btn.pack(fill="x", pady=3)
            self.nav_buttons[screen_id] = btn

        profile = ctk.CTkFrame(self.sidebar, fg_color=SIDEBAR_HOVER, corner_radius=12)
        profile.pack(fill="x", padx=16, pady=20)
        ctk.CTkLabel(
            profile, text="Admin User", font=FONT_BODY, text_color="#ffffff"
        ).pack(anchor="w", padx=14, pady=(12, 0))
        ctk.CTkLabel(
            profile, text="admin@threadflow.com", font=FONT_SMALL, text_color=SIDEBAR_MUTED
        ).pack(anchor="w", padx=14, pady=(0, 12))

        # --- Main area ---
        self.main_area = ctk.CTkFrame(self, fg_color=CONTENT_BG, corner_radius=0)
        self.main_area.grid(row=0, column=1, sticky="nsew")
        self.main_area.grid_rowconfigure(1, weight=1)
        self.main_area.grid_columnconfigure(0, weight=1)

        # Header
        self.header = ctk.CTkFrame(self.main_area, height=64, fg_color=CONTENT_BG, corner_radius=0)
        self.header.grid(row=0, column=0, sticky="ew", padx=24, pady=(16, 0))
        self.header_title = ctk.CTkLabel(
            self.header, text="Dashboard", font=FONT_HEADING, text_color=TEXT_PRIMARY
        )
        self.header_title.pack(side="left")

        self.global_search = ctk.CTkEntry(
            self.header,
            placeholder_text="Global search…",
            width=260,
            height=38,
            corner_radius=20,
            border_color="#cbd5e1",
        )
        self.global_search.pack(side="right")
        self.global_search.bind("<Return>", self._global_search)

        # Content container
        self.content = ctk.CTkFrame(self.main_area, fg_color="transparent")
        self.content.grid(row=1, column=0, sticky="nsew", padx=24, pady=16)

    def _build_screens(self):
        self.screens["dashboard"] = DashboardScreen(self.content, self)

        for table_key in ("customer", "product", "sale", "inventory"):
            screen_id = f"crud_{table_key}"
            self.screens[screen_id] = CrudScreen(self.content, table_key)

        self.screens["queries"] = QueriesScreen(self.content)
        self.screens["views"] = ViewsScreen(self.content)
        self.screens["routines"] = RoutinesScreen(
            self.content,
            on_data_changed=self._refresh_crud_screens,
        )

    def show_screen(self, screen_id):
        """Switch visible content and highlight sidebar item."""
        for frame in self.screens.values():
            frame.pack_forget()

        screen = self.screens.get(screen_id)
        if screen:
            screen.pack(fill="both", expand=True)
            self.current_screen = screen_id
            self.header_title.configure(text=PAGE_TITLES.get(screen_id, ""))

            for sid, btn in self.nav_buttons.items():
                if sid == screen_id:
                    btn.configure(fg_color=SIDEBAR_ACTIVE, hover_color=SIDEBAR_ACTIVE)
                else:
                    btn.configure(fg_color="transparent", hover_color=SIDEBAR_HOVER)

            if screen_id == "dashboard" and hasattr(screen, "refresh_data"):
                screen.refresh_data()
            elif screen_id.startswith("crud_") and hasattr(screen, "refresh_data"):
                screen.refresh_data()

    def _global_search(self, _event=None):
        """Navigate to Customers CRUD and apply search term."""
        term = self.global_search.get().strip()
        if not term:
            return
        self.show_screen("crud_customer")
        screen = self.screens.get("crud_customer")
        if screen and hasattr(screen, "search_entry"):
            screen.search_entry.delete(0, "end")
            screen.search_entry.insert(0, term)
            screen._apply_search()

    def _refresh_crud_screens(self):
        for sid in ("crud_sale", "crud_inventory"):
            screen = self.screens.get(sid)
            if screen and hasattr(screen, "refresh_data"):
                screen.refresh_data()
        dashboard = self.screens.get("dashboard")
        if dashboard and hasattr(dashboard, "refresh_data"):
            dashboard.refresh_data()

    def _test_connection(self):
        try:
            import db

            db.fetch_one("SELECT 1")
        except Exception as exc:
            messagebox.showwarning(
                "Connection Warning",
                "Could not connect to PostgreSQL.\n"
                "Check config.py and ensure the database is running.\n\n"
                f"Error: {exc}",
            )


def main():
    app = App()
    app.mainloop()


if __name__ == "__main__":
    main()
