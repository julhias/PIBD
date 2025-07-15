# ui/motorista_window.py
import tkinter as tk
from tkinter import ttk, messagebox
from database.queries import cadastrar_novo_motorista

class MotoristaWindow(tk.Toplevel):
    def __init__(self, master):
        super().__init__(master)
        self.title("Cadastrar Novo Motorista")
        self.geometry("450x450")
        self.transient(master)
        self.grab_set()

        # Frame com scroll
        canvas = tk.Canvas(self)
        scrollbar = ttk.Scrollbar(self, orient="vertical", command=canvas.yview)
        scrollable_frame = ttk.Frame(canvas)

        scrollable_frame.bind("<Configure>", lambda e: canvas.configure(scrollregion=canvas.bbox("all")))
        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        
        # Campos do formulário
        self.fields = {}
        labels = [
            "CPF (11 dígitos, sem pontos):", "Nome Completo:", "Email:", "Telefone:",
            "Senha:", "CNH:", "Data Validade CNH (AAAA-MM-DD):", "Categoria CNH (ex: AB):"
        ]
        
        for i, label_text in enumerate(labels):
            ttk.Label(scrollable_frame, text=label_text).grid(row=i, column=0, sticky="w", padx=10, pady=5)
            entry = ttk.Entry(scrollable_frame, width=40)
            entry.grid(row=i, column=1, padx=10, pady=5)
            # Adiciona ao dicionário com uma chave mais simples
            key = label_text.split(" ")[0].lower().replace(':', '') # <--- AQUI ESTÁ A MUDANÇA
            self.fields[key] = entry

        # Botão de cadastro
        btn_cadastrar = ttk.Button(scrollable_frame, text="Cadastrar", command=self.cadastrar)
        btn_cadastrar.grid(row=len(labels), columnspan=2, pady=20)

    def cadastrar(self):
        # Coleta os dados dos campos
        dados = {key: entry.get() for key, entry in self.fields.items()}

        # Validação simples
        for key, value in dados.items():
            if not value:
                messagebox.showwarning("Campo Obrigatório", f"O campo '{key.capitalize()}' não pode estar vazio.")
                return

        success, message = cadastrar_novo_motorista(
            cpf=dados['cpf'], nome=dados['nome'], email=dados['email'], telefone=dados['telefone'],
            senha=dados['senha'], cnh=dados['cnh'], data_valid=dados['data'], categoria=dados['categoria']
        )

        if success:
            messagebox.showinfo("Sucesso", message)
            self.destroy() # Fecha a janela
        else:
            messagebox.showerror("Erro", message)