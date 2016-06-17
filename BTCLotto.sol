import "./RoundLib.sol";


contract BTCLotto{
  using RoundLib for RoundLib.Round;
  address btcRelay = 0x41f274c0023f83391de4e0733c609df5a124c3d4;
  uint i;
  mapping(uint => RoundLib.Round) rounds;
  uint maxVal;
  uint constant roundLen = 6;
  uint constant price = 1 ether;

  function BTCLotto(address relay, uint max){
    if(relay != 0){
      btcRelay = relay;
    }

    maxVal = max;
  }

  function newRound(){
    uint blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
    rounds[i].newRound(blockHeight, price, maxVal);
  }

  function buyTicket(uint roundIndex){
    rounds[roundIndex].buyTickets(btcRelay);
  }

  function payOut(uint roundIndex){
    rounds[roundIndex].payOut(btcRelay);
  }




}
