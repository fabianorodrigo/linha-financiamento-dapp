pragma solidity 0.5.7;

import "./Gerenciavel.sol";

/**
 * Linha de Financiamento é uma aplicacao descentralizada para gerenciamento
 * de um linha de credito publica ficticia utilizada para fins academicos
 *
 * Originalmente criada em: <https://github.com/fabianorodrigo/linha-financiamento-dapp>.
 */
contract LinhaFinanciamento is Gerenciavel {
    struct Financiamento {
        address origem;
        uint64 cpf;
        uint8 idade;
        bool microEmpreendedor;
        bool estudante;
        uint256 valor;
        bool aprovado;
        uint8 taxa;
        address gerente;
    }

    uint256 private capital;

    constructor(uint256 capitalLF) public Gerenciavel() {
        capital = capitalLF;
    }

    Financiamento[] private financiamentos;

    function solicitar(
        uint64 cpf,
        uint8 idade,
        bool microEmpreendedor,
        bool estudante,
        uint256 valor
    ) public naoGerente {
        require(cpf > 0, "O CPF do proponente deve ser informado");
        require(idade >= 18, "O proponente deve ser maior de idade");
        require(
            microEmpreendedor || estudante,
            "Esta linha de financiamento eh restrita a microempreendedores e estudantes"
        );
        financiamentos.push(
            Financiamento(
                msg.sender,
                cpf,
                idade,
                microEmpreendedor,
                estudante,
                valor,
                false,
                0,
                address(0)
            )
        );
    }

    function deliberar(uint256 indiceArray, bool aprovado)
        public
        somenteGerente
    {
        require(
            financiamentos.length > indiceArray,
            "A solicitacao de financiamento nao existe"
        );
        require(
            financiamentos[indiceArray].gerente == address(0) &&
                financiamentos[indiceArray].taxa == 0,
            "Jah houve deliberacao em relacao a esta solicitacao de financiamento"
        );
        Financiamento memory f = financiamentos[indiceArray];
        if (aprovado) {
            uint8 taxa;
            if (f.microEmpreendedor && f.estudante) {
                if (f.idade > 65) {
                    taxa = 15; //1,5% aa
                } else {
                    taxa = 20; //2,0% aa
                }
            } else {
                if (f.idade > 65) {
                    taxa = 21; //2,1% aa
                } else {
                    taxa = 25; //2,5% aa
                }
            }
            f.aprovado = true;
        } else {
            f.aprovado = false;
        }
        f.gerente = msg.sender;
        financiamentos[indiceArray] = f;
    }
}
