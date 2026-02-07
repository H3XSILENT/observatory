#!/usr/bin/env bash
# Hexilent Software: 2026-02-07
# Program name: rvuln
# License: MIT - see LICENSE file in the repository


INPUT_FILE=""
SCOPE_FILE=""

# Help menu
usage() {
    echo "Uso: $0 [-e|--escopo ARQUIVO] [arquivo_entrada]"
    echo "  -e, --escopo   Arquivo com escopo permitido (um domínio/path por linha)"
    echo "  -h, --help     Mostra essa ajuda"
    exit 1
}

# Banner
echo -e "\\e[96m"
cat << "EOF"
______________   ____    .__          
\______   \   \ /   /_ __|  |   ____  
 |       _/ \   Y   /  |  \  |  /    \ 
 |    |   \ \     /|  |  /  |_|   |  \
 |____|_  /  \___/ |____/|____/___|  /
        \/                         \/ 水
EOF
echo -e "\\e[0m"

# Verifica se o usuário chamou --help
for arg in "$@"; do
    case "$arg" in
        -h|--help)
            usage
            ;;
        -e|--escopo)
            ;;
        -*)
            echo "Opção inválida: $arg"
            usage
            ;;
    esac
done

# Processa flags
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -e|--escopo)
            SCOPE_FILE="$2"
            shift 2
            ;;
        -*)
            echo "Opção inválida: $1"
            usage
            ;;
        *)
            INPUT_FILE="$1"
            shift
            ;;
    esac
done

# Falha se não tiver arquivo de entrada
if [ -z "$INPUT_FILE" ]; then
    echo -e "\\e[33;1mAtenção!!!\\e[0m"
    echo "Argumentos incompletos..."
    echo "Informe o arquivo de entrada."
    usage
fi

# Verifica se o arquivo de entrada existe
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "\\e[31;1mErro: Arquivo de entrada não existe: $INPUT_FILE\\e[0m"
    exit 1
fi

# Verifica se o diretório de saída já existe
if [ -e "${INPUT_FILE}.dir" ]; then
    echo -e "\\e[33;1mAtenção:\\e[0m"
    echo "Diretório '${INPUT_FILE}.dir' já existe."
    echo "Se você não o criou, delete-o e tente novamente."
    exit 1
fi

# Criar diretório de trabalho e entrar
mkdir "${INPUT_FILE}.dir"
cd "${INPUT_FILE}.dir" || exit 1

# Coleta de subdomínios
subfinder -dL "$INPUT_FILE" -silent -o subs_subfinder.txt

# Verifica se findomain está disponível
if command -v findomain >/dev/null 2>&1; then
    findomain -f "$INPUT_FILE" --output -o findomain_out.txt
else
    echo "findomain não encontrado. Pulando..." >&2
    touch findomain_out.txt
fi

# Junta subdomínios e remove duplicatas
cat subs_subfinder.txt findomain_out.txt | sort -u > subs.txt

# Remove arquivos temporários
rm -f subs_subfinder.txt findomain_out.txt

# Procura hosts ativos com httpx (substituindo httprobe)
cat subs.txt | httpx -silent -o resolv.txt

# Reconhecimento de URLs (gau + hakrawler)
if [[ -n "$SCOPE_FILE" ]]; then
    if [ ! -f "$SCOPE_FILE" ]; then
        echo -e "\\e[31;1mErro: Arquivo de escopo não existe: $SCOPE_FILE\\e[0m"
        exit 1
    fi

    # URL discovery com escopo
    cat resolv.txt | gau --subdomains --threads 25 | grep -F -f "$SCOPE_FILE" > gau.txt
    cat resolv.txt | hakrawler -plain -t 25 | grep -F -f "$SCOPE_FILE" > hraw.txt
else
    # URL discovery sem escopo
    cat resolv.txt | gau --subdomains --threads 25 > gau.txt
    cat resolv.txt | hakrawler -plain -t 25 > hraw.txt
fi

cat gau.txt hraw.txt | sort -u > urls.txt
rm -f gau.txt hraw.txt

# Coleta de parâmetros e teste de parâmetros refletidos
cat urls.txt | grep "=" > parameters.txt
cat parameters.txt | sed 's/=.*/=/' | sort -u > parameters_c.txt

# Gxss (se disponível)
if command -v Gxss >/dev/null 2>&1; then
    cat parameters_c.txt | Gxss > reflected.txt
else
    echo "Gxss não encontrado. Pulando teste de parâmetros refletidos." >&2
    touch reflected.txt
fi

# Reconhecimento de tecnologias (wad)
if command -v wad >/dev/null 2>&1; then
    wad -u @urls.txt -o tech.json
else
    echo "wad não encontrado. Pulando detecção de tecnologias." >&2
fi

# Verificação de status com httpx
STATUS_CODE="200,201,204,301,302,307,308,401,403,405,500,502,503,504"
FLAGS_EXTRAS="-title -cl -location -rt -tech-detect -silent -timeout 8 -threads 50"
TEMP_OUTPUT="httpx_temp_$(date +%Y%m%d_%H%M%S).txt"

httpx -l urls.txt -sc -mc "$STATUS_CODE" $FLAGS_EXTRAS > "$TEMP_OUTPUT"

# Relatório organizado
REPORT_FILE="status_code.txt"

{
    echo "=============================================================="
    echo "       RELATÓRIO ORGANIZADO - httpx $(date '+%Y-%m-%d %H:%M')"
    echo "=============================================================="
    echo ""

    echo "[+] 2xx - Conteúdo encontrado / Páginas vivas"
    echo "------------------------------------------------"
    grep -E "\\[200\\]|\\[201\\]|\\[204\\]" "$TEMP_OUTPUT" | sort -u || echo "Nenhum encontrado"
    echo ""

    echo "[+] Redirecionamentos (301/302/307/308)"
    echo "------------------------------------------------"
    grep -E "\\[301\\]|\\[302\\]|\\[307\\]|\\[308\\]" "$TEMP_OUTPUT" | sort -u || echo "Nenhum encontrado"
    echo ""

    echo "[+] Restritos / Autenticação necessária (401/403)"
    echo "------------------------------------------------"
    grep -E "\\[401\\]|\\[403\\]" "$TEMP_OUTPUT" | sort -u || echo "Nenhum encontrado"
    echo "  → Priorize esses para testar bypass, IDOR, exposed panels, etc."
    echo ""

    echo "[+] 405 - Método não permitido (recurso existe!)"
    echo "------------------------------------------------"
    grep "\\[405\\]" "$TEMP_OUTPUT" | sort -u || echo "Nenhum encontrado"
    echo "  → Teste outros métodos (POST, PUT, DELETE...)"
    echo ""

    echo "[+] Erros de servidor (500/502/503/504)"
    echo "------------------------------------------------"
    grep -E "\\[500\\]|\\[502\\]|\\[503\\]|\\[504\\]" "$TEMP_OUTPUT" | sort -u || echo "Nenhum encontrado"
    echo "  → Pode ter stack traces, debug ou comportamentos estranhos"
    echo ""

    echo "=============================================================="
    echo "Saída bruta completa está em: $TEMP_OUTPUT"
    echo "Total de linhas interessantes: $(wc -l < "$TEMP_OUTPUT" 2>/dev/null || echo 0)"
    echo "=============================================================="
} > "$REPORT_FILE"

rm -f "$TEMP_OUTPUT"

# Frags de URLs
cat urls.txt | grep "#" > fragments.txt

# Scanners automatizados

# SQLi com sqlmap
if command -v sqlmap >/dev/null 2>&1; then
    sqlmap -m parameters.txt --batch --dbs --threads=5 --level=3 --risk=3 \
        -o "SQMAP_${INPUT_FILE}.txt" 2>&1
else
    echo "sqlmap não encontrado. Pulando SQLi." >&2
fi

# CRLF com crlfuzz
if command -v crlfuzz >/dev/null 2>&1; then
    crlfuzz -l parameters_c.txt -c 25 -o "CRL_${INPUT_FILE}.txt"
else
    echo "crlfuzz não encontrado. Pulando CRLF." >&2
fi

# Subdomain takeover com subjack
if command -v subjack >/dev/null 2>&1; then
    subjack -w subs.txt -v -t 25 -o "TAKEOVER_${INPUT_FILE}.txt"
else
    echo "subjack não encontrado. Pulando subdomain takeover." >&2
fi

# Nuclei
if command -v nuclei >/dev/null 2>&1; then
    nuclei -l urls.txt -t /usr/share/nuclei-templates/http -c 25 \
        -o "NUCLEI_${INPUT_FILE}.txt"
else
    echo "nuclei não encontrado. Pulando Nuclei." >&2
fi

# XSS com dalfox
if command -v dalfox >/dev/null 2>&1; then
    dalfox file parameters.txt --batch -o "DALFOX-XSS_${INPUT_FILE}.txt"
else
    echo "dalfox não encontrado. Pulando XSS (dalfox)." >&2
fi

echo -e "\\e[32;1mExecução finalizada com sucesso.\\e[0m"
