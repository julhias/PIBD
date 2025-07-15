# ui/itinerario_window.py
import tkinter as tk
from tkinter import ttk, messagebox
from database.queries import get_all_linhas, get_itinerario_por_linha

class ItinerarioWindow(tk.Toplevel):
    def __init__(self, master):
        super().__init__(master)
        self.title("Consultar Itinerário")
        self.geometry("500x400")
        self.transient(master) # Mantém a janela no topo
        self.grab_set() # Impede interação com a janela principal

        # Frame
        frame = ttk.Frame(self, padding="10")
        frame.pack(expand=True, fill="both")

        # Label e Combobox para selecionar a linha
        ttk.Label(frame, text="Selecione a Linha:").pack(anchor="w")
        self.linhas_combobox = ttk.Combobox(frame, state="readonly")
        self.linhas_combobox.pack(fill="x", pady=5)
        self.load_linhas()

        # Botão de busca
        ttk.Button(frame, text="Buscar Pontos", command=self.buscar_itinerario).pack(pady=10)

        # Área de resultados
        ttk.Label(frame, text="Pontos de Parada:").pack(anchor="w")
        self.result_text = tk.Text(frame, height=15, width=60, state="disabled")
        self.result_text.pack(expand=True, fill="both")

    def load_linhas(self):
        linhas = get_all_linhas()
        if linhas:
            self.linha_map = {f"{l['nome_linha']} (ID: {l['id_linha']})": l['id_linha'] for l in linhas}
            self.linhas_combobox['values'] = list(self.linha_map.keys())
        else:
            messagebox.showerror("Erro", "Não foi possível carregar as linhas do banco de dados.")

    def buscar_itinerario(self):
        selected_text = self.linhas_combobox.get()
        if not selected_text:
            messagebox.showwarning("Aviso", "Por favor, selecione uma linha.")
            return

        linha_id = self.linha_map.get(selected_text)
        itinerario = get_itinerario_por_linha(linha_id)

        self.result_text.config(state="normal")
        self.result_text.delete(1.0, tk.END)

        if itinerario:
            for ponto in itinerario:
                self.result_text.insert(tk.END, f"- {ponto['endereco']} (Tipo: {ponto['tipo']})\n")
        else:
            self.result_text.insert(tk.END, "Nenhum ponto de parada encontrado para esta linha.")
        
        self.result_text.config(state="disabled")