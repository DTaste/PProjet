contract PiOFileCertifier {
	
	struct HashRecord {
		address publisher;
		uint timestamp;
                string filename;
		string fileurl;                
		uint blockNumber;
	}
    

	mapping(bytes32 => HashRecord) private hash_records;
	event PublishEvent (address indexed _from, bytes32 hash);

		
	address pio_owner;
    
	function PiOFileCertifier(){
		pio_owner = msg.sender; 
	}

	function publish(bytes32 hash, string filename, string fileurl) returns (bool success) {
	
		if (documentExists(hash)) {
			return false;
	    }else{

        		
			hash_records[hash].publisher = msg.sender;
                        hash_records[hash].filename = filename;
			hash_records[hash].fileurl = fileurl;
			hash_records[hash].blockNumber = block.number;
	        	hash_records[hash].timestamp = now;

			PublishEvent(msg.sender,hash);
	
			return true;
	        }
	        

    	}

	function updateURL (bytes32 hash, string fileurl) returns (bool success) {
		if (documentExists(hash)) {
			if(hash_records[hash].publisher == msg.sender) {
				hash_records[hash].fileurl = fileurl;
				return true;
			} 
			
		}

		return false;
	}
	

	function getHashRecord(bytes32 hash) constant returns (address publisher, uint timestamp, string filename, string fileurl, uint blockNumber) {
		HashRecord record = hash_records[hash];        
		publisher = record.publisher;
		timestamp = record.timestamp;
                filename = record.filename;
		fileurl = record.fileurl;
		blockNumber = record.blockNumber;
	}

    

	function documentExists(bytes32 hash) constant returns (bool exists){
        	if (hash_records[hash].timestamp != 0) {
        		return true;
        	}
		return false;
	}
	
	function kill() {
            if (msg.sender != pio_owner) return;
            suicide(pio_owner);   
        }

}

