# 🚀 Guia Completo — MkDocs + Poetry + GitHub Pages

Este guia ensina passo a passo como instalar, configurar e publicar documentação profissional usando **MkDocs** com **Poetry** e **GitHub Pages** — ideal para ambientes **WSL + Ubuntu + VSCode**.

---

## 📦 1️⃣ Instalar o Poetry

```bash
# Instalar Poetry
curl -sSL https://install.python-poetry.org | python3 -

# Reiniciar o shell
exec $SHELL

# Verificar instalação
poetry --version
```

---

## 🧱 2️⃣ Criar Projeto Base

```bash
# Criar novo projeto
poetry new docs-site

# Entrar na pasta
cd docs-site
```

---

## ⚙️ 3️⃣ Adicionar MkDocs e Tema Material

```bash
# Adicionar dependências
poetry add mkdocs mkdocs-material
```

---

## 🗂️ 4️⃣ Criar Estrutura Inicial

```bash
poetry run mkdocs new .
```

Isso cria:

```
docs-site/
├── docs/
│   └── index.md
├── mkdocs.yml
└── pyproject.toml
```

---

## ▶️ 5️⃣ Rodar o Servidor Local

```bash
poetry run mkdocs serve
```
Abra no navegador: [http://127.0.0.1:8000](http://127.0.0.1:8000)

---

## 🧩 6️⃣ Iniciar Git e Criar Repositório no GitHub

```bash
git init
git add .
git commit -m "init: documentação com MkDocs e Poetry"
```

Crie um repositório em [https://github.com/new](https://github.com/new), e conecte:

```bash
git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
git branch -M main
git push -u origin main
```

---

## 🚢 7️⃣ Fazer Deploy no GitHub Pages

```bash
poetry run mkdocs gh-deploy --force
```

Isso:
- Gera o site em `site/`
- Cria o branch `gh-pages`
- Publica automaticamente no GitHub Pages

---

## 🌍 8️⃣ Habilitar GitHub Pages

1. Vá para **Settings → Pages** no repositório.  
2. Em **Source**, selecione o branch `gh-pages`.  
3. Clique em **Save**.  

Seu site estará em:
```
https://seu_usuario.github.io/seu_repositorio/
```

---

## ⚙️ 9️⃣ Estrutura Recomendada de Navegação

Exemplo de estrutura no `mkdocs.yml`:

```yaml
site_name: "Academus Docs"
theme:
  name: material
  language: pt
  palette:
    - scheme: default
      primary: indigo
      accent: deep purple
```

---

## 🧠 10️⃣ Automatizar Deploy com GitHub Actions

Crie o arquivo `.github/workflows/deploy.yml`:

```yaml
name: Deploy Docs

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Install Poetry
        run: curl -sSL https://install.python-poetry.org | python3 -
      - name: Install Dependencies
        run: poetry install
      - name: Build and Deploy
        run: poetry run mkdocs gh-deploy --force
```

---

## 🏁 Resumo Rápido

| Etapa | Comando |
|-------|----------|
| Instalar Poetry | `curl -sSL https://install.python-poetry.org | python3 -` |
| Adicionar MkDocs | `poetry add mkdocs mkdocs-material` |
| Criar estrutura | `poetry run mkdocs new .` |
| Servir localmente | `poetry run mkdocs serve` |
| Deploy manual | `poetry run mkdocs gh-deploy --force` |
| Deploy automático | GitHub Actions com `deploy.yml` |

---

**Autor:** [@mandresoeiro](https://github.com/mandresoeiro)  
**Projeto:** [Academus Docs](https://mandresoeiro.github.io/academus-docs/)
