// We will be using Solidity version 0.5.4
pragma solidity 0.5.4;
// Importing OpenZeppelin's SafeMath Implementation
import 'https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol';


contract PopupProjects {
    using SafeMath for uint256;

    // List of existing projects
    Crowdfunding[] private crowdfundings;

    // Event that will be emitted whenever a new project is started
    event CrowdfundingStarted(
        address crowdfundingAddress,
        address crowdfundingStarter,
        string crowdfundingTitle,
        string crowdfundingDesc
    );

    /** @dev Function to start a new crowdfunding.
      * @param crowdfundingTitle Title of the project to be created
      * @param crowdfundingDescription Brief description about the project
      */
    function startCrowdfunding(
        string calldata crowdfundingTitle,
        string calldata crowdfundingDescription
    ) external {
        Crowdfunding newCrowdfunding = new Crowdfunding(msg.sender, crowdfundingTitle, crowdfundingDescription);
        crowdfundings.push(newCrowdfunding);
        emit CrowdfundingStarted(
            address(newCrowdfunding),
            msg.sender,
            crowdfundingTitle,
            crowdfundingDescription
        );
    }                                                                                                                                   

    /** @dev Function to get all projects' contract addresses.
      * @return A list of all projects' contract addreses
      */
    function returnAllCrowdfundings() external view returns(Crowdfunding[] memory){
        return crowdfundings;
    }
}


contract Crowdfunding {
    using SafeMath for uint256;

    // State variables
    address payable public CFcreator;
    string public CFtitle;
    string public CFdescription;
    address payable public CFparentContractAddress;

    // List of existing projects
    Project[] private projects;

    // Event that will be emitted whenever a new project is started
    event ProjectStarted(
        address contractAddress,
        address projectStarter,
        string projectTitle,
        string projectDesc,
        uint256 deadline,
        uint256 goalAmount
    );

constructor
    (
        address payable crowdfundingStarter,
        string memory crowdfundingTitle,
        string memory crowdfundingDesc
    ) public {
        CFcreator = crowdfundingStarter;
        CFtitle = crowdfundingTitle;
        CFdescription = crowdfundingDesc;
        CFparentContractAddress = msg.sender;
    }

    /** @dev Function to start a new project.
      * @param CCtitle Title of the project to be created
      * @param CCdescription Brief description about the project
      * @param CCdurationInDays Project deadline in days
      * @param CCamountToRaise Project goal in wei
      */
    function startProject(
        string calldata CCtitle,
        string calldata CCdescription,
        uint CCdurationInDays,
        uint CCamountToRaise
    ) external {
        uint CCraiseUntil = now.add(CCdurationInDays.mul(1 days));
        Project newProject = new Project(msg.sender, CCtitle, CCdescription, CCraiseUntil, CCamountToRaise);
        projects.push(newProject);
        emit ProjectStarted(
            address(newProject),
            msg.sender,
            CCtitle,
            CCdescription,
            CCraiseUntil,
            CCamountToRaise
        );
    }                                                                                                                                   

    /** @dev Function to get all projects' contract addresses.
      * @return A list of all projects' contract addreses
      */
    function returnAllProjects() external view returns(Project[] memory){
        return projects;
    }


    /** @dev Function to get specific information about the project.
      * @return Returns all the project's details
      */
    function getDetails() public view returns 
    (
        address payable crowdfundingStarter,
        string memory crowdfundingTitle,
        string memory crowdfundingDesc,
        address payable crowdfundingParentContractAddress,
        address crowdfundingMyContractAddress
    ) {
        crowdfundingStarter = CFcreator;
        crowdfundingTitle = CFtitle;
        crowdfundingDesc = CFdescription;
        crowdfundingParentContractAddress = CFparentContractAddress;
        crowdfundingMyContractAddress = address(this);
    }

}


contract Project {
    using SafeMath for uint256;
    
    // Data structures
    enum State {
        Fundraising,
        Expired,
        Successful
    }

    // State variables
    address payable public creator;
    uint public amountGoal; // required to reach at least this much, else everyone gets refund
    uint public completeAt;
    uint256 public currentBalance;
    uint public raiseBy;
    string public title;
    string public description;
    State public state = State.Fundraising; // initialize on create
    mapping (address => uint) public contributions;
    address payable public parentContractAddress;

    // Event that will be emitted whenever funding will be received
    event FundingReceived(address contributor, uint amount, uint currentTotal);
    // Event that will be emitted whenever the project starter has received the funds
    event CreatorPaid(address recipient);

    // Modifier to check current state
    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    // Modifier to check if the function caller is the project creator
    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    constructor
    (
        address payable projectStarter,
        string memory projectTitle,
        string memory projectDesc,
        uint fundRaisingDeadline,
        uint goalAmount
    ) public {
        creator = projectStarter;
        title = projectTitle;
        description = projectDesc;
        amountGoal = goalAmount;
        raiseBy = fundRaisingDeadline;
        currentBalance = 0;
        parentContractAddress = msg.sender;
    }

    /** @dev Function to fund a certain project.
      */
    function contribute() external inState(State.Fundraising) payable {
        require(msg.sender != creator);
        contributions[msg.sender] = contributions[msg.sender].add(msg.value);
        currentBalance = currentBalance.add(msg.value);
        emit FundingReceived(msg.sender, msg.value, currentBalance);
        checkIfFundingCompleteOrExpired();
    }

    /** @dev Function to change the project state depending on conditions.
      */
    function checkIfFundingCompleteOrExpired() public {
        if (currentBalance >= amountGoal) {
            state = State.Successful;
            payOut();
        } else if (now > raiseBy)  {
            state = State.Expired;
        }
        completeAt = now;
    }

    /** @dev Function to give the received funds to project starter.
      */
    function payOut() internal inState(State.Successful) returns (bool) {
        uint256 totalRaised = currentBalance;
        currentBalance = 0;

        if (creator.send(totalRaised)) {
            emit CreatorPaid(creator);
            return true;
        } else {
            currentBalance = totalRaised;
            state = State.Successful;
        }

        return false;
    }

    /** @dev Function to retrieve donated amount when a project expires.
      */
    function getRefund() public inState(State.Expired) returns (bool) {
        require(contributions[msg.sender] > 0);

        uint amountToRefund = contributions[msg.sender];
        contributions[msg.sender] = 0;

        if (!msg.sender.send(amountToRefund)) {
            contributions[msg.sender] = amountToRefund;
            return false;
        } else {
            currentBalance = currentBalance.sub(amountToRefund);
        }

        return true;
    }

    /** @dev Function to get specific information about the project.
      * @return Returns all the project's details
      */
    function getDetails() public view returns 
    (
        address payable projectStarter,
        string memory projectTitle,
        string memory projectDesc,
        uint256 deadline,
        State currentState,
        uint256 currentAmount,
        uint256 goalAmount,
        address payable projectParentContractAddress,
        address projectMyContractAddress
    ) {
        projectStarter = creator;
        projectTitle = title;
        projectDesc = description;
        deadline = raiseBy;
        currentState = state;
        currentAmount = currentBalance;
        goalAmount = amountGoal;
        projectParentContractAddress = parentContractAddress;
        projectMyContractAddress = address(this);
    }
}
