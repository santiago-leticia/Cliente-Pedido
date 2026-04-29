-- RM565799: Leticia Santiago e Silva
-- RM564992: Natan Freitas de Moraes

set serveroutput on;
set verify off;

DROP TABLE CP2_PEDIDOS;
DROP TABLE CP2_CLIENTES;

SELECT SYSDATE from dual;

CREATE TABLE CP2_CLIENTES (
 id_cliente number(2) primary key,
 nome VARCHAR2(20),
 status char(1) CHECK (status = 'A' or status = 'I')
);

CREATE TABLE CP2_PEDIDOS(
    id_pedido number(2) PRIMARY KEY,
    id_cliente number(2),
    valor number(8,2),
    data_pedido DATE,
    categoria VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES CP2_CLIENTES(id_cliente)
);

declare
    v_id_cliente number(2) := &id_cliente;
    v_nome VARCHAR(20) := '&nome';
    v_status char(1) := '&status';
    
    v_id_pedido number(2) := &id_pedido;
    v_valor number(8,2) := &valor_pedido;
    v_data_pedido DATE := '&data_pedido';
begin
    INSERT INTO CP2_CLIENTES (id_cliente, nome, status ) VALUES (v_id_cliente, v_nome, v_status);
    INSERT INTO CP2_PEDIDOS (id_pedido, id_cliente, valor, data_pedido ) VALUES (v_id_pedido, v_id_cliente, v_valor, v_data_pedido);
end;

DECLARE 
    CURSOR c_pedidos IS SELECT * FROM CP2_PEDIDOS where data_pedido >= '01-APR-26';
    CURSOR c_clientes IS SELECT * FROM CP2_CLIENTES;
    
    v_pedidos_alterados number(2) := 0;
    v_valor_processado number(8,2) := 0;
BEGIN
    FOR v_cursor in c_pedidos loop
        for c_cursor in c_clientes loop
            IF (c_cursor.id_cliente = v_cursor.id_cliente) then
                dbms_output.put_line('ID cliente: '||c_cursor.id_cliente);
                dbms_output.put_line('Nome do cliente: '||c_cursor.nome);
                dbms_output.put_line('Status do cliente: '||c_cursor.status);
            end if;
        end loop;
        IF (v_cursor.valor > 1000) THEN
            UPDATE CP2_PEDIDOS SET categoria = 'PREMIUM' WHERE id_pedido = v_cursor.id_pedido;
            v_pedidos_alterados := v_pedidos_alterados + 1;
            v_valor_processado := v_valor_processado + v_cursor.valor;
        ELSE 
            UPDATE CP2_PEDIDOS SET categoria = 'COMUM' WHERE id_pedido = v_cursor.id_pedido;
            v_pedidos_alterados := v_pedidos_alterados + 1;
            v_valor_processado := v_valor_processado + v_cursor.valor;
        end if;
    end loop;
    dbms_output.put_line('===============================================');
    dbms_output.put_line('Pedidos alterados: '||v_pedidos_alterados);
    dbms_output.put_line('Valor total processado: '||v_valor_processado);
END;
    
    
    
    
    







