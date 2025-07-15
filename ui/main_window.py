# ui/main_window.py
import tkinter as tk
from tkinter import ttk
from ui.itinerario_window import ItinerarioWindow
from ui.motorista_window import MotoristaWindow
from ui.manutencao_window import ManutencaoWindow

class MainWindow(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Portal de Transporte e Mobilidade")
        self.geometry("400x300")

        # Estilo
        self.style = ttk.Style(self)
        self.style.configure('TButton', font=('Helvetica', 12), padding=10)
        self.style.configure('TLabel', font=('Helvetica', 14, 'bold'), padding=10)

        # Frame principal
        main_frame = ttk.Frame(self, padding="20")
        main_frame.pack(expand=True, fill="both")

        # Título
        title_label = ttk.Label(main_frame, text="Menu Principal", anchor="center")
        title_label.pack(pady=10)

        # Botões
        btn_itinerario = ttk.Button(main_frame, text="Consultar Itinerário", command=self.open_itinerario_window)
        btn_itinerario.pack(fill="x", pady=5)

        btn_cad_motorista = ttk.Button(main_frame, text="Cadastrar Novo Motorista", command=self.open_motorista_window)
        btn_cad_motorista.pack(fill="x", pady=5)
        
        btn_reg_manutencao = ttk.Button(main_frame, text="Registrar Manutenção de Veículo", command=self.open_manutencao_window)
        btn_reg_manutencao.pack(fill="x", pady=5)

    def open_itinerario_window(self):
        ItinerarioWindow(self)

    def open_motorista_window(self):
        MotoristaWindow(self)
        
    def open_manutencao_window(self):
        ManutencaoWindow(self)