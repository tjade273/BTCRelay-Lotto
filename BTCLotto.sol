import "./RoundLib.sol";
import "./PriceFeed.sol";
//import "./BlockhashFetch.sol";
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
    int blockHeight = BTCRelay(btcRelay).getLastBlockHeight();
    rounds[i].newRound(blockHeight, price, maxVal);
  }

  function buyTicket(uint roundIndex){
    rounds[roundIndex].buyTickets();
    BoughtTicket(roundIndex, msg.sender, msg.value/price);
  }

  function payOut(uint roundIndex){
    rounds[roundIndex].payOut();
  }

  function getRound(uint i) constant returns (address[], uint, int, RoundLib.Phase){
      return (rounds[i].tickets,rounds[i].value,rounds[i].btcBlockNum,rounds[i].phase);
  }

/*
  function updateMaxVal(){
   uint val = PriceFeed.price();

    maxVal = (10^6/val)*25;
  }

*/

}
