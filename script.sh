#!/bin/bash


PGPASSWORD="senhadobanco"
PGHOST="hostdobanco"
PGUSER="userdobanco"
PGDATABASE="nomedobanco"


read -p "Digite o número dos pedidos a serem gerados: " variavelentrada #a partir dessa entrada será utilizado o valor na query

nomearquivoxml=P8001$(date +%d%m%Y%H%M)


# Define output XML file
OUTPUT_XML="$nomearquivoxml.xml"
echo '<?xml version="1.0" standalone="yes"?>' > $OUTPUT_XML
echo '<NewDataSet>' >> $OUTPUT_XML


# Conectar no banco de dados e realizar uma query jogando pro CSV
PGPASSWORD="$PGPASSWORD" psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -c "\COPY ( 
SELECT
    cc.campo1, 
    cc.campo2 AS pedido, 
    cc.campo3, 
    os.campo4, 
    (oo.campo5 AT TIME ZONE 'UTC' AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '6 hours') AS DatadeCriacao,
    (s1.campo6 AT TIME ZONE 'UTC' AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '6 hours') AS DataPagamento,
    CASE
        WHEN s1.campo6 IS NULL THEN 'Sem data'
        ELSE TO_CHAR(s1.campo6, 'YYYY_MM')
    END AS MesPagamento,
    CASE
        WHEN oo.campo7 IS NULL THEN 'Sem data'
        ELSE TO_CHAR(oo.campo7, 'YYYY_MM')
    END AS ???,
    s1.??? AS ???,
    SUM(osi.??? * osi.???) AS ???,
    SUM(osi.???) AS ???,
    oo.campo9 AS ???,
    SUM(osi.???) AS ???,
    oo.reusefee AS ???,
    (oo.campo9 + oo.???) AS ???
FROM
    tabela oo
INNER JOIN tabela 2 os ON ??? = ???
INNER JOIN tabela 3 cc ON ??? = ???
INNER JOIN tabela 4 cd ON ??? = ???
INNER JOIN tabelaitems osi ON ??? = ???
INNER JOIN (
    SELECT 
        op.blabla,
        SUM(CASE WHEN op.??? > 0 THEN op.??? ELSE op.??? END) AS ???,
        MAX(???) AS ???
    FROM 
        ??? op
    WHERE 
        op.??? IN (1, 2, 3, 4, 10, 14, 18)
    GROUP BY op.???
) s1 ON oo.id = s1.???
WHERE cc.campo2 in ($variavelentrada)
    AND oo.??? = '79638307-2d03-4780-8159-971b6a4c22a8'
    AND oo.??? IN (3, 5)
    AND (oo.campo9 + oo.???) != 0
GROUP BY 
    cc.campo2, cc.???, cc.???, oo.???, oo.???, oo.???,
    s1.campo8, s1.campo6, oo.campo7, oo.campo5, 
    os.???, cc.campo1, os.campo4
ORDER BY 
    cc.campo2 DESC
) TO './saida.csv' with CSV"




PGPASSWORD="$PGPASSWORD" psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -c "\COPY ( 
SELECT
    cc.campo1, 
    cc.campo2 AS pedido, 
    cc.campo3, 
    os.campo4, 
    (oo.campo5 AT TIME ZONE 'UTC' AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '6 hours') AS DatadeCriacao,
    (s1.campo6 AT TIME ZONE 'UTC' AT TIME ZONE 'America/Sao_Paulo' - INTERVAL '6 hours') AS DataPagamento,
    CASE
        WHEN s1.campo6 IS NULL THEN 'Sem data'
        ELSE TO_CHAR(s1.campo6, 'YYYY_MM')
    END AS MesPagamento,
    CASE
        WHEN oo.campo7 IS NULL THEN 'Sem data'
        ELSE TO_CHAR(oo.campo7, 'YYYY_MM')
    END AS ???,
    s1.??? AS ???,
    SUM(osi.??? * osi.???) AS ???,
    SUM(osi.???) AS ???,
    oo.campo9 AS ???,
    SUM(osi.???) AS ???,
    oo.??? AS ???,
    (oo.??? + oo.???) AS ???
FROM
    tabela oo
INNER JOIN tabela 2 os ON ??? = ???
INNER JOIN tabela 3 cc ON ??? = ???
INNER JOIN tabela 4 cd ON ??? = ???
INNER JOIN tabelaitems osi ON ??? = ???
INNER JOIN (
    SELECT 
        op.blabla,
        SUM(CASE WHEN op.??? > 0 THEN op.??? ELSE op.??? END) AS ???,
        MAX(???) AS ???
    FROM 
        ??? op
    WHERE 
        op.??? IN (1, 2, 3, 4, 10, 14, 18)
    GROUP BY op.???
) s1 ON oo.id = s1.???
WHERE cc.campo2 in ($variavelentrada)
    AND oo.??? = '79638307-2d03-4780-8159-971b6a4c22a8'
    AND oo.??? IN (3, 5)
    AND (oo.campo9 + oo.???) != 0
GROUP BY 
    cc.campo2, cc.???, cc.???, oo.???, oo.???, oo.???,
    s1.campo8, s1.campo6, oo.campo7, oo.campo5, 
    os.???, cc.campo1, os.campo4
ORDER BY 
    cc.campo2 DESC
) TO './saida.csv' with CSV"



# Criação do Loop de leitura da planilha para preencher o arquivo xml (cada variavel mencionada aqui será direcionada no XML mais pra frente
tail -n +1 saida.csv | while IFS=',' read -r variavel1 variavel2 variavel3 variavel4 variavel5 variavel6 variavel7 variavel8 variavel9 variavel10 variavel11 variavel12 variavel13 variavel14 variavel15; do

set +e

dia=$(echo "$variavel4" | cut -d ' ' -f1 | cut -d '-' -f3) ##tratar a data vinda do banco pra mostrar apenas o dia


##eliminar a limitação do bash 08 e 09 (não pode ser feito cancelos com numemeros 08 e 09 pelo bash
if [ "$dia" -eq 08 ]; then
    dia=8
elif [ "$dia" -eq 09 ]; then
    dia=9
fi


# Calcular a semana do mês
semana_do_mes=$(( ($dia + 6) / 7 ))

dataanopedido=$(echo $mespagamento | cut -d "_" -f1)

# echo $dia



    # As variaveis estão repetidas porem cada variavel declarada na linha 132 seria um campo aqui
    cat <<EOF >> $OUTPUT_XML&
    <PedidoCarga>
        <SIGLA>BHZ</SIGLA>
        <NUM_CGC_TITULAR>${variavel1}</NUM_CGC_TITULAR>
        <CHAVE_IDENTIF>${variavel1}</CHAVE_IDENTIF>
        <PCE_ANO_PEDIDO>$variavel1</PCE_ANO_PEDIDO>
        <PCE_VALOR_ESTIMADO_PEDIDO>${variavel1}</PCE_VALOR_ESTIMADO_PEDIDO>
        <PCE_JUROS_PEDIDO>${variavel1}</PCE_JUROS_PEDIDO>
        <PCE_VALOR_ISSQN>${variavel1}</PCE_VALOR_ISSQN>
        <SEMANA_PEDIDO>${variavel1}</SEMANA_PEDIDO>
        <DATA_PEDIDO>${variavel1}</DATA_PEDIDO>
        <VALOR_PAGTO>${variavel1}</VALOR_PAGTO>
        <VALOR_OPERADORA>${variavel1}</VALOR_OPERADORA>
        <TX_ADM_SALDO>${variavel1}</TX_ADM_SALDO>
        <DATA_PAGTO>${variavel1}</DATA_PAGTO>
        <CODIGO_CONTROLE>${variavel1}${variavel1}</CODIGO_CONTROLE>
        <TIPO_PEDIDO>B</TIPO_PEDIDO>
        <VALOR_TX_ENTREGA>0</VALOR_TX_ENTREGA>
		<QUANTIDADE>1</QUANTIDADE>
        <DATA_VENCIMENTO>${variavel1}</DATA_VENCIMENTO>
        <TIPO_BOLETO>2</TIPO_BOLETO>
        <STATUS_COBRANCA>6</STATUS_COBRANCA>
        <DATA_PAGAMENTO>${variavel1}</DATA_PAGAMENTO>
        <VALOR_BOLETO>0</VALOR_BOLETO>
        <VALOR_COBRADO>${variavel1}</VALOR_COBRADO>
        <VALOR>${variavel1}</VALOR>
    </PedidoCarga>
EOF


done



# Close the XML file
echo '</NewDataSet>' >> $OUTPUT_XML

sed -i 's/\b0\.0\b/0/g' $OUTPUT_XML


