import "./RoundLib.sol";

contract BTCRelay {
    function getBlockHash(uint blockHeight) returns (uint);
    function getLastBlockHeight() returns (uint);
}

contract BTCLotto{
  using RoundLib for RoundLib.Round;
  address btcRelay = "0x41f274c0023f83391de4e0733c609df5a124c3d4";
  uint i;
  mapping(uint => RoundLib.Round) rounds;
  uint constant maxVal;
  uint constant roundLen = 6;
  uint constant price = 1 ether;

  function BTCLotto(address relay, uint max){
    if(relay != 0){
      btcRelay = relay;
    }

    maxVal = max;
  }

  function newRound(){
    rounds[i].newRound()
  }

  function buyTicket(uint roundIndex){
    rounds[roundIndex].buyTickets(BTCRelay(btcRelay).getLastBlockHeight() + roundLen, price, maxVal);
  }

  function payOut(uint roundIndex){
    rounds[roundIndex].payOut(btcRelay);
  }

  


}
