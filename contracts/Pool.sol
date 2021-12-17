// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
import "./Project.sol";

contract Pool {

    event Create(address creator,string name);
    //enum State {initialized, ongoing, completed}
    uint public id;
    uint256 public projectcount;
    //uint256 public currentBal;
    Project [] public projectsListed;
    //State public currentState;
    uint public poolValue;
    address public owner;
    string public name;
    mapping(address => uint) sponsorFunds;
      uint[] matchRatio;
      address payable ownerproj;
    //modifier to allow access only to the owner
    modifier isOwner() {
        require(msg.sender == owner, "Cannot allow access other than owner");
        _;
    }
    
    //modifier to allow the function to proceed only if contract is in intended state
    //modifier isState(State reqState) {
    //    require(currentState == reqState, "Contract not in required state");
      //  _;
   // }
    
    //initializes the owner of the contract and currentState of the contract to initialized.
    constructor (uint idnumber,string memory nam,address creator) public {
        owner = creator;
        id=idnumber;
        name=nam;
       // currentState = State.initialized;
    }
    
    //function to change the currentState variable of the contract based on comparing block timestamp 
    //to constant raiseBy and startRaisingFrom to meet isState modifier requirements. Currently only
    //the owner can change the phase but chainlink keeper can be implemented later to automate the 
    //change state process.
    //TODO check the access specifier
   // function changeState(uint state) public isOwner {
    
    //    require(currentState!=State.completed||state==1||state==2, "Invalid State");
        
    //    if(currentState==State.initialized && state == 1 && address(this).balance>10 ether){
   //         currentState=State.ongoing;
   //     }
    //    else if(currentState==State.ongoing){
    //    currentState=State.completed;
    //    }
  //  }
 
    //function to recieve funds from sponsors to make up the pool
    function recieveToPool () public payable {
            sponsorFunds[msg.sender] = sponsorFunds[msg.sender] + msg.value;
            poolValue+=msg.value;
    }
    
    //function to pay the project owner his match by multiplying the match ratio with the total poolValue
    function payoutPoolMatch(uint matchRatio, address payable projectOwner) internal {
        projectOwner.transfer(matchRatio*poolValue);
    }

    function createProject(string memory name, string memory imag, string memory des) public  {

       Project newProject = new Project(payable(msg.sender), name, imag, des);
       projectcount++;
       emit Create(msg.sender,name);
       projectsListed.push(newProject);
    }

    function listprojects() public view returns (Project[] memory)
   {
       return projectsListed;
   }

 
    //this function recieves the square of sum of sqrt of contributions recieved by individual projects 
   //and sums it by iterating over the projectsListed array. It iterates the projectsListed array once 
   //again, calculates the match ratio and calls the payout function in pool contract with the required 
   //arguments. Since this computation requires very much gas this can be computed off chain using
   //chainlink external adapters which can be later implemented.
   function calandPayoutMatch() public payable 
   {
    uint256 sumSquaredSqrtFundsSum;
    uint256 aas;
    poolValue=address(this).balance;
    for(uint i = 0; i < projectcount; i++){
        //sumSquaredSqrtFundsSum.add(projectsListed[i].getSquaredSqrtFundsSum());
        
        sumSquaredSqrtFundsSum += projectsListed[i].sqsum()*projectsListed[i].sqsum();
      
    }
    require(sumSquaredSqrtFundsSum>0,"No contributions recorded");

    for(uint j = 0; j < projectcount; j++)
    {
           // redundant variable array matchRatio
           //require(projectsListed[j].sqsum()>0,"sumproj is zero");

           aas = (projectsListed[j].sqsum()*projectsListed[j].sqsum());
           
          // projectsListed[j].owner().transfer(aas*poolValue);
           //payoutPoolMatch(aas, projectsListed[j].owner());
          // projectsListed[i].owner().transfer(1);
            if(aas*poolValue/sumSquaredSqrtFundsSum<=address(this).balance){
          (projectsListed[j].owner()).transfer(aas*poolValue/sumSquaredSqrtFundsSum);
           }
           else if(address(this).balance!=0)
           {
            (projectsListed[j].owner()).transfer(address(this).balance);
           }
           else
           {
             break;
           }
           
    }
  }
  }
      
