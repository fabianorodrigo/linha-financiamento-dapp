pragma solidity 0.5.7;

import "./Gerenciavel.sol";

contract LinhaFinanciamento is Gerenciavel {
  struct Financiamento {
    address origem;
    uint8 idade;
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

  function solicitar(uint8 idade, uint256 valor) public naoGerente {
    require(idade >= 18, "O proponente deve ser maior de idade");
    financiamentos.push(Financiamento(msg.sender, idade, valor, false, 0, address(0)));
  }

  function deliberar(uint256 indiceArray, bool aprovado) public somenteGerente {
    require(financiamentos.length >= indiceArray, "A solicitacao nao existe");
    require(
      financiamentos[indiceArray].gerente == address(0) && financiamentos[indiceArray].taxa == 0,
      "Solicitacao ja deliberada"
    );
    Financiamento memory f = financiamentos[indiceArray];
    if (aprovado) {
      uint8 taxa;
      if (f.idade > 65) {
        taxa = 15; //1,5% aa
      } else {
        taxa = 20; //2,0% aa
      }
      f.aprovado = true;
      capital = capital - f.valor;
    } else {
      f.aprovado = false;
    }
    f.gerente = msg.sender;
    financiamentos[indiceArray] = f;
  }
}
