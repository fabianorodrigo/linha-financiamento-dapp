pragma solidity 0.5.7;

contract Gerenciavel {
    /** atual gerente da dApp */
    address private gerente;

    constructor() public {
        gerente = msg.sender;
    }

    modifier somenteGerente {
        require(
            msg.sender == gerente,
            "Somente o gerente desta dApp pode executar esta operacao"
        );
        _;
    }
    modifier naoGerente {
        require(
            msg.sender != gerente,
            "O gerente desta dApp nao pode executar esta operacao"
        );
        _;
    }

    function mudarGerente(address novoGerente) public somenteGerente {
        gerente = novoGerente;
    }
}
