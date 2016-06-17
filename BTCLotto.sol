import "./RoundLib.sol";


contract BTCLotto{
  using RoundLib for RoundLib.Round;
  address public btcRelay = 0x41f274c0023f83391de4e0733c609df5a124c3d4;
  uint i;
  mapping(uint => RoundLib.Round) rounds;
  uint maxVal;
  uint constant public roundLen = 6;
  uint constant public price = 1 ether;

  event BoughtTicket(uint id, address buyer, uint num);

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
    BoughtTicket(roundIndex, msg.sender, msg.value/price);
  }

  function payOut(uint roundIndex){
    rounds[roundIndex].payOut(btcRelay);
  }

  function getRound(uint i) constant returns (address[], uint, uint, RoundLib.Phase){
      return (rounds[i].tickets,rounds[i].value,rounds[i].btcBlockNum,rounds[i].phase);
  }




}
