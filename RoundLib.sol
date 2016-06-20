library RoundLib{

  enum Phase {Buy, Wait, Claim, Ended}
  struct Round {
    uint btcBlockNum;
    uint maxVal;
    uint price;

    address[] tickets;
    uint value;

    Phase phase;
  }

  function newRound(Round storage self, uint blockNumber, uint price, uint maxVal){
    self.btcBlockNum = blockNumber;
    self.maxVal = maxVal;
    self.price = price;
  }

  function buyTickets(Round storage self, address btcRelay){
    updatePhase(self, btcRelay);

    if(self.phase != Phase.Buy) throw;
    if(self.value + msg.value > self.maxVal) throw;

    for(uint i; i<msg.value/self.price; i++){
      self.tickets.push(msg.sender);
    }

    self.value += msg.value;


  }

  function payOut(Round storage self, address btcRelay){
    updatePhase(self, btcRelay);

    if(self.phase != Phase.Claim) throw;

    uint blockHash = BTCRelay(btcRelay).getBlockHash(self.btcBlockNum);

    if(blockHash == 0) throw;

    address winner = self.tickets[uint(sha3(blockHash))%self.tickets.length];

    self.phase = Phase.Ended;
    winner.send(self.value);
  }

  function updatePhase(Round storage self, address btcRelay){
    uint block = BTCRelay(btcRelay).getLastBlockHeight();
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
