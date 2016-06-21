contract BTCRelay {
    function getBlockHeader(int blockHash) returns (bytes32[3]);
    function getLastBlockHeight() returns (int);
    function getBlockchainHead() returns (int);
    function getFeeAmount(int blockHash) returns (int);
}


contract BlockhashFetch {

  BTCRelay relay;
  mapping(uint => uint) blockHashes;

  function BlockhashFetch(address _relay){
    relay = BTCRelay(_relay);
  }


  function getPrevHash(int prevHash) returns (bytes32 hash){

    uint fee = uint(relay.getFeeAmount(prevHash));
    bytes32 head = relay.getBlockHeader.value(fee)(prevHash)[2];
    bytes32 temp;

    assembly {
        let x := mload(0x40)
        mstore(x,head)
        temp := mload(add(x,0x04))
    }

    for(uint i; i<32; i++){
      hash = hash | bytes32(uint(temp[i]) * (0x100**i));
    }


    return hash;
  }



}
