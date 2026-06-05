"""
Shared UI theme, colors, and reusable CustomTkinter components.
Presentation layer only – no database logic.
"""

import tkinter as tk
from tkinter import ttk

import customtkinter as ctk

# --- Color palette (inspired by modern admin dashboards) ---
SIDEBAR_BG = "#1e293b"
SIDEBAR_HOVER = "#334155"
SIDEBAR_ACTIVE = "#2563eb"
SIDEBAR_TEXT = "#e2e8f0"
SIDEBAR_MUTED = "#94a3b8"

CONTENT_BG = "#f1f5f9"
CARD_BG = "#ffffff"
BORDER = "#e2e8f0"

ACCENT_BLUE = "#2563eb"
ACCENT_ORANGE = "#f97316"
ACCENT_GREEN = "#16a34a"
ACCENT_PURPLE = "#7c3aed"
ACCENT_RED = "#dc2626"

TEXT_PRIMARY = "#0f172a"
TEXT_SECONDARY = "#64748b"

FONT_FAMILY = "Segoe UI"
FONT_TITLE = (FONT_FAMILY, 22, "bold")
FONT_HEADING = (FONT_FAMILY, 16, "bold")
FONT_SUBHEADING = (FONT_FAMILY, 13, "bold")
FONT_BODY = (FONT_FAMILY, 12)
FONT_SMALL = (FONT_FAMILY, 11)
FONT_STAT = (FONT_FAMILY, 28, "bold")


def configure_app_theme():
    """Apply global CustomTkinter appearance."""
    ctk.set_appearance_mode("light")
    ctk.set_default_color_theme("blue")


def card(parent, **kwargs):
    """Rounded white content card."""
    defaults = {
        "fg_color": CARD_BG,
        "corner_radius": 14,
        "border_width": 1,
        "border_color": BORDER,
    }
    defaults.update(kwargs)
    return ctk.CTkFrame(parent, **defaults)


def primary_button(parent, text, command, color=ACCENT_BLUE, width=120):
    return ctk.CTkButton(
        parent,
        text=text,
        command=command,
        width=width,
        height=36,
        corner_radius=10,
        fg_color=color,
        hover_color=_darken(color),
        font=FONT_BODY,
    )


def secondary_button(parent, text, command, width=120):
    return ctk.CTkButton(
        parent,
        text=text,
        command=command,
        width=width,
        height=36,
        corner_radius=10,
        fg_color="#e2e8f0",
        hover_color="#cbd5e1",
        text_color=TEXT_PRIMARY,
        font=FONT_BODY,
    )


def danger_button(parent, text, command, width=120):
    return primary_button(parent, text, command, color=ACCENT_RED, width=width)


def _darken(hex_color, factor=0.85):
    hex_color = hex_color.lstrip("#")
    r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
    r, g, b = int(r * factor), int(g * factor), int(b * factor)
    return f"#{r:02x}{g:02x}{b:02x}"


def section_title(parent, text, subtitle=None):
    """Page heading inside main content."""
    wrap = ctk.CTkFrame(parent, fg_color="transparent")
    ctk.CTkLabel(wrap, text=text, font=FONT_TITLE, text_color=TEXT_PRIMARY).pack(anchor="w")
    if subtitle:
        ctk.CTkLabel(wrap, text=subtitle, font=FONT_BODY, text_color=TEXT_SECONDARY).pack(
            anchor="w", pady=(2, 0)
        )
    return wrap


def crud_treeview(parent, columns, headings, height=8):
    """
    Enhanced Treeview for CRUD screens: taller rows, strong headers, styled scrollbars.
    Returns (tree, container_frame).
    """
    container = ctk.CTkFrame(parent, fg_color="#f8fafc", corner_radius=10, border_width=1, border_color=BORDER)
    style = ttk.Style()
    style.theme_use("clam")

    style.configure(
        "Crud.Treeview",
        background="#ffffff",
        foreground=TEXT_PRIMARY,
        fieldbackground="#ffffff",
        rowheight=38,
        font=(FONT_FAMILY, 12),
        borderwidth=0,
    )
    style.configure(
        "Crud.Treeview.Heading",
        background="#e2e8f0",
        foreground=TEXT_PRIMARY,
        font=(FONT_FAMILY, 12, "bold"),
        relief="flat",
        padding=(10, 8),
    )
    style.map(
        "Crud.Treeview",
        background=[("selected", "#bfdbfe")],
        foreground=[("selected", TEXT_PRIMARY)],
    )
    style.configure(
        "Crud.Vertical.TScrollbar",
        background="#cbd5e1",
        troughcolor="#f1f5f9",
        borderwidth=0,
        arrowsize=14,
    )
    style.configure(
        "Crud.Horizontal.TScrollbar",
        background="#cbd5e1",
        troughcolor="#f1f5f9",
        borderwidth=0,
        arrowsize=14,
    )

    tree_frame = tk.Frame(container, bg="#f8fafc")
    tree_frame.pack(fill="both", expand=True, padx=6, pady=6)

    tree = ttk.Treeview(
        tree_frame,
        columns=columns,
        show="headings",
        height=height,
        style="Crud.Treeview",
        selectmode="browse",
    )
    tree.tag_configure("odd", background="#ffffff")
    tree.tag_configure("even", background="#f8fafc")

    for col_id, label in zip(columns, headings):
        tree.heading(col_id, text=label)
        tree.column(col_id, width=115, minwidth=75, stretch=True)

    scroll_y = ttk.Scrollbar(
        tree_frame, orient="vertical", command=tree.yview, style="Crud.Vertical.TScrollbar"
    )
    scroll_x = ttk.Scrollbar(
        tree_frame, orient="horizontal", command=tree.xview, style="Crud.Horizontal.TScrollbar"
    )
    tree.configure(yscrollcommand=scroll_y.set, xscrollcommand=scroll_x.set)
    tree.grid(row=0, column=0, sticky="nsew")
    scroll_y.grid(row=0, column=1, sticky="ns")
    scroll_x.grid(row=1, column=0, sticky="ew")
    tree_frame.grid_rowconfigure(0, weight=1)
    tree_frame.grid_columnconfigure(0, weight=1)
    return tree, container


def populate_tree_rows(tree, rows):
    """Insert rows with alternating stripe tags."""
    for item in tree.get_children():
        tree.delete(item)
    for index, row in enumerate(rows):
        tag = "even" if index % 2 == 0 else "odd"
        tree.insert("", tk.END, values=row, tags=(tag,))


def styled_treeview(parent, columns, headings, height=12):
    """
    ttk.Treeview inside a styled frame (CustomTkinter has no native table widget).
    Returns (tree, container_frame).
    """
    container = ctk.CTkFrame(parent, fg_color=CARD_BG, corner_radius=10)
    style = ttk.Style()
    style.theme_use("clam")
    style.configure(
        "Modern.Treeview",
        background="#ffffff",
        foreground=TEXT_PRIMARY,
        fieldbackground="#ffffff",
        rowheight=30,
        font=(FONT_FAMILY, 11),
        borderwidth=0,
    )
    style.configure(
        "Modern.Treeview.Heading",
        background="#f8fafc",
        foreground=TEXT_SECONDARY,
        font=(FONT_FAMILY, 11, "bold"),
        relief="flat",
        padding=(8, 6),
    )
    style.map(
        "Modern.Treeview",
        background=[("selected", "#dbeafe")],
        foreground=[("selected", TEXT_PRIMARY)],
    )

    tree_frame = tk.Frame(container, bg=CARD_BG)
    tree_frame.pack(fill="both", expand=True, padx=4, pady=4)

    tree = ttk.Treeview(
        tree_frame,
        columns=columns,
        show="headings",
        height=height,
        style="Modern.Treeview",
    )
    for col_id, label in zip(columns, headings):
        tree.heading(col_id, text=label)
        tree.column(col_id, width=110, minwidth=70, stretch=True)

    scroll_y = ttk.Scrollbar(tree_frame, orient="vertical", command=tree.yview)
    scroll_x = ttk.Scrollbar(tree_frame, orient="horizontal", command=tree.xview)
    tree.configure(yscrollcommand=scroll_y.set, xscrollcommand=scroll_x.set)
    tree.grid(row=0, column=0, sticky="nsew")
    scroll_y.grid(row=0, column=1, sticky="ns")
    scroll_x.grid(row=1, column=0, sticky="ew")
    tree_frame.grid_rowconfigure(0, weight=1)
    tree_frame.grid_columnconfigure(0, weight=1)
    return tree, container


def dynamic_treeview(parent, height=15):
    """Treeview with columns set later – for queries/views results."""
    container = ctk.CTkFrame(parent, fg_color=CARD_BG, corner_radius=10)
    style = ttk.Style()
    style.theme_use("clam")
    style.configure("Modern.Treeview", rowheight=30, font=(FONT_FAMILY, 11))
    style.configure("Modern.Treeview.Heading", font=(FONT_FAMILY, 11, "bold"))

    tree_frame = tk.Frame(container, bg=CARD_BG)
    tree_frame.pack(fill="both", expand=True, padx=4, pady=4)

    tree = ttk.Treeview(tree_frame, show="headings", height=height, style="Modern.Treeview")
    scroll_y = ttk.Scrollbar(tree_frame, orient="vertical", command=tree.yview)
    scroll_x = ttk.Scrollbar(tree_frame, orient="horizontal", command=tree.xview)
    tree.configure(yscrollcommand=scroll_y.set, xscrollcommand=scroll_x.set)
    tree.grid(row=0, column=0, sticky="nsew")
    scroll_y.grid(row=0, column=1, sticky="ns")
    scroll_x.grid(row=1, column=0, sticky="ew")
    tree_frame.grid_rowconfigure(0, weight=1)
    tree_frame.grid_columnconfigure(0, weight=1)
    return tree, container
