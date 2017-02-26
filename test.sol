contract test{

    struct User{
        string selfData;
        string secretDataHash;
        bool isUserDead;
    }
    struct EmergencyUserList{
        string name;
        address emerAddress;
        bool isEmerContactDead;
    }
    mapping (address => uint256) public countOfMyAddedBeneficiary;
    mapping (address => uint256) public countOfMyAddedValidator;
    mapping (address => uint256) public individualCountOfWhomImABeneficaryOf;
    mapping (address => uint256) public individualCountOfWhomImAValidatorOf;
    mapping (address => mapping ( uint256 => address)) listOfthosePeopleWhoHaveMadeMeTheirBeneficiary;
    mapping (address => mapping ( uint256 => address)) listOfthosePeopleWhoHaveMadeMeTheirValidator;
    mapping (address => User) public users;
    mapping (address => mapping(address=> EmergencyUserList)) public beneficiaryDetails;
    mapping (address => mapping(address=> EmergencyUserList)) public ValidatorDetails;
    mapping (address => mapping ( uint256 => address)) public BeneficiaryLists;
    mapping (address => mapping ( uint256 => address)) public ValidatorLists;
    mapping (address => uint256 ) public alertCount;
    event BeneficiaryAdded(address indexed _sender, address indexed _beneficiaryAddress, string indexed _name, string _msg);
    event ValidatorAdded(address indexed _sender,  address indexed _validatorAddress, string indexed _name, string _msg);
    event NoReponseSinceLast180Days(address _sender, string _msg);
    
    ///set the self details
    function setSelfDetail(string _selfDataHash) {
        if (users[msg.sender].isUserDead == false){
        users[msg.sender].selfData = _selfDataHash;
        }
    }
    ///get the self details
    function getSelfDetail() constant returns(string){
        if (users[msg.sender].isUserDead == false){
        return users[msg.sender].selfData;
        }
    }
    ///set the secret info details
    function setSecretInfo(string _secretDataHash){
        if (users[msg.sender].isUserDead == false){
            users[msg.sender].secretDataHash = _secretDataHash;
            alertCount[msg.sender] = 0;
        }
    }
    ///get the secret info details
    function getSecretInfo()constant returns (string){
        if (users[msg.sender].isUserDead == false){
            return users[msg.sender].secretDataHash;
        }
        else 
            return "No Such User Exist or User is Dead";
    }
    
    ///store the BENEFICIARY 
    function addBeneficiary(string _name, address _address){
        if (users[msg.sender].isUserDead == false){
        beneficiaryDetails[msg.sender][_address].name = _name;
        beneficiaryDetails[msg.sender][_address].emerAddress = _address;
        beneficiaryDetails[msg.sender][_address].isEmerContactDead = false;
        BeneficiaryLists[msg.sender][countOfMyAddedBeneficiary[msg.sender]++] = _address ;
        listOfthosePeopleWhoHaveMadeMeTheirBeneficiary[_address][individualCountOfWhomImABeneficaryOf[_address]++] = msg.sender;
        //event beneficiary Added
        BeneficiaryAdded(msg.sender, _address , _name, "Beneficiary added successfully.");
    }
    }
    
    ///store the Validator
    function addValidator(string _name, address _address){
        if (users[msg.sender].isUserDead == false){
        ValidatorDetails[msg.sender][_address].name = _name;
        ValidatorDetails[msg.sender][_address].emerAddress = _address;
        ValidatorDetails[msg.sender][_address].isEmerContactDead = false;
        ValidatorLists[msg.sender][countOfMyAddedValidator[msg.sender]++] = _address ;
        listOfthosePeopleWhoHaveMadeMeTheirValidator[_address][individualCountOfWhomImAValidatorOf[_address]++] = msg.sender;
        //event beneficiary Added
        ValidatorAdded(msg.sender, _address , _name, "Validator added successfully.");
         }
    }
    
    // some data has to be stored at the central DB. for sending the reminders on each 30'th day
    // how would I know that now is the 30 days
    // in case of No Response, we shall call increaseAlertCounter method
    function increaseAlertCounter(address _address){
        alertCount[_address]++;
        if (alertCount[_address]>5){
            users[_address].isUserDead = true;
          NoReponseSinceLast180Days(_address,"We got no response from this address in last 180 days. send email to BENEF/VALIDATOR") ;
        }
    }

    function resetAlertCounter(address _address){
        alertCount[_address]=0;
        users[_address].isUserDead = false;
    }
    
    function OfficiallyDead(address _address){
        users[_address].isUserDead = true;
    }
    
    function NotDead (){
        
    }
}
