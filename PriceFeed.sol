import "./oraclizeAPI.sol";

contract PriceFeed is usingOraclize {

  uint public price; // Price * 10^6

  function PriceFeed(){

  }

  function getPrice(){
    oraclize_query("URL", "json(http://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.p.0");
  }

  function __callback(bytes32 id, string result){
     if (msg.sender != oraclize_cbAddress()) throw;

    price =  parseInt(result, 6);
  }

}
