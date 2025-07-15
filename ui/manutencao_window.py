# ui/manutencao_window.py
import tkinter as tk
from tkinter import ttk, messagebox
from database.queries import get_all_veiculos_ativos, registrar_manutencao_veiculo

class ManutencaoWindow(tk.Toplevel):
    def __init__(self, master):
        super().__init__(master)
        self.title("Registrar Manutenção de Veículo")
        self.geometry("500x200")
        self.transient(master)
        self.grab_set()

        frame = ttk.Frame(self, padding="20")
        frame.pack(expand=True, fill="both")

        ttk.Label(frame, text="Selecione o Veículo Ativo:").pack(anchor="w")

        self.veiculos_combobox = ttk.Combobox(frame, state="readonly", width=50)
        self.veiculos_combobox.pack(fill="x", pady=5)
        self.load_veiculos()

        ttk.Button(frame, text="Enviar para Manutenção", command=self.registrar_manutencao).pack(pady=20)

    def load_veiculos(self):
        veiculos = get_all_veiculos_ativos()
        if veiculos:
            self.veiculo_map = {f"Placa: {v['placa']} ({v['tipo_veiculo']})": v['veiculoId'] for v in veiculos}
            self.veiculos_combobox['values'] = list(self.veiculo_map.keys())
        else:
            messagebox.showerror("Erro", "Não foi possível carregar os veículos ativos.")

    def registrar_manutencao(self):
        selected_text = self.veiculos_combobox.get()
        if not selected_text:
            messagebox.showwarning("Aviso", "Por favor, selecione um veículo.")
            return
        
        veiculo_id = self.veiculo_map.get(selected_text)
        
        confirm = messagebox.askyesno(
            "Confirmar Ação", 
            f"Tem certeza que deseja enviar o veículo de placa '{selected_text.split(' ')[1]}' para manutenção?"
        )

        if confirm:
            success, message = registrar_manutencao_veiculo(veiculo_id)
            if success:
                messagebox.showinfo("Sucesso", message)
                self.destroy()
            else:
                messagebox.showerror("Erro", message)