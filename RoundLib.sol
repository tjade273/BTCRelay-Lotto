import "./BlockhashFetch.sol";
library RoundLib{

  enum Phase {Buy, Wait, Claim, Ended}
  struct Round {
    int btcBlockNum;
    uint maxVal;
    uint price;

    address[] tickets;
    uint value;

    Phase phase;
  }
  address constant btcRelay = 0x41f274c0023f83391de4e0733c609df5a124c3d4;
  address constant btcRelayFetch = 0x32304cdbe41fe4f1c48b08356414a52957d22d3b;

  function newRound(Round storage self, int blockNumber, uint price, uint maxVal){
    self.btcBlockNum = blockNumber;
    self.maxVal = maxVal;
    self.price = price;
  }

  function buyTickets(Round storage self){
    updatePhase(self);

    if(self.phase != Phase.Buy) throw;
    if(self.value + msg.value > self.maxVal) throw;

    for(uint i; i<msg.value/self.price; i++){
      self.tickets.push(msg.sender);
    }

    self.value += msg.value;


  }

  function payOut(Round storage self){
    updatePhase(self);

    if(self.phase != Phase.Claim) throw;
    uint fee;
    bytes32 blockHash;
    (blockHash, fee)= BlockhashFetch(btcRelayFetch).getBlockHash(int(self.btcBlockNum));

    if(blockHash == 0) throw;

    address winner = self.tickets[uint(sha3(blockHash))%self.tickets.length];

    self.phase = Phase.Ended;
    winner.send(self.value);
  }

  function updatePhase(Round storage self){
    int block = BTCRelay(btcRelay).getLastBlockHeight();
    if(self.phase == Phase.Ended) return;
    if(block-1 >  self.btcBlockNum){
      self.phase = Phase.Buy;
    }
    else if(block-1 == self.btcBlockNum) {
      self.phase = Phase.Wait;
    }
    else{
      self.phase = Phase.Claim;
    }
  }
}
