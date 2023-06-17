pragma solidity 0.8.17;

contract Election {

    //user for login
    struct user
    {
        string logaddr;
        string passwordReal;
        string passwordFake;
    }
    //candidate
    struct Candidate{
        uint id;
        string name;
        uint voteCount;  
    }
    //voter data
    struct Voter{
        uint voterid;
        string addr;
        uint vid;
        uint votefor;
    }
    //fake voter data
    struct FakeVoter{
        uint voterid;
        string addr;
        uint vid;
        uint votefor;
    }
    //events
    event userCreated(
      string logaddr,
      string passwordReal,
      string passwordFake
    );

    constructor() {
        addCandidate("Cat");
        addCandidate("Dog");
    }

    uint public userCount = 0;
    mapping(string => user) public usersList;
    mapping (uint => Candidate) public candidates;
    mapping (uint => Voter) public voters;
    mapping (uint => FakeVoter) public fakevoters;
    mapping (address => bool) public voter;
    uint public candidatecount;
    uint public votercount;
    
    //create user for login function
    function createUser(string memory _logaddr,
                      string memory _passwordReal,
                      string memory _passwordFake) public
    {     
      userCount++;
      usersList[_logaddr] = user(_logaddr, _passwordReal,  _passwordFake);
      emit userCreated(_logaddr, _passwordReal, _passwordFake);
    }

    //add candidate funcion
    function addCandidate (string memory _name) public {
        candidatecount++;
        candidates[candidatecount] = Candidate(candidatecount, _name, 0);
    }

    //cast a real vote function
    function realvote (uint _candidateid, uint _vid, string memory _voteraddr, uint _AddressInt) public {
        require (!voter[msg.sender]);
        require (_candidateid > 0 && _candidateid <= candidatecount);
        //voter[msg.sender] = true;
        candidates[_candidateid].voteCount++;

        votercount++;
        voters[_vid] = Voter(votercount, _voteraddr, _vid, _candidateid);
        voters[_AddressInt] = Voter(votercount, _voteraddr, _vid, _candidateid);
    }

    //cast a fake vote function
    function fakevote (uint _candidateid, uint _vid, string memory _voteraddr) public {
        require (!voter[msg.sender]);
        require (_candidateid > 0 && _candidateid <= candidatecount);
        //voter[msg.sender] = true;

        votercount++;
        fakevoters[_vid] = FakeVoter(votercount, _voteraddr, _vid, _candidateid);
    }

    //Revise a vote
    function multiplevote (uint _candidateid, uint _reducecandidateid, uint _vid, string memory _voteraddr, uint _AddressInt) public {
        require (!voter[msg.sender]);
        require (_candidateid > 0 && _candidateid <= candidatecount);
        //voter[msg.sender] = true;
        candidates[_candidateid].voteCount++;
        candidates[_reducecandidateid].voteCount--;

        votercount++;
        voters[_vid] = Voter(votercount, _voteraddr, _vid, _candidateid);
        voters[_AddressInt] = Voter(votercount, _voteraddr, _vid, _candidateid);
    }

    //login
    function getaddr (string memory _logaddr) public view returns (string memory) {
        return (usersList[_logaddr].logaddr);
    }
    function getpasswordReal (string memory _logaddr) public view returns (string memory) {
        return (usersList[_logaddr].passwordReal);
    }
    function getpasswordFake (string memory _logaddr) public view returns (string memory) {
        return (usersList[_logaddr].passwordFake);
    }

    //vote

    //candidates
    function getid (uint _candidateid) public view returns (uint) {
        return (candidates[_candidateid].id);
    }
    function getname (uint _candidateid) public view returns (string memory) {
        return (candidates[_candidateid].name);
    }
    function getcount (uint _candidateid) public view returns (uint) {
        return (candidates[_candidateid].voteCount);
    }

    //search real voter
    function getvoter (uint _vid) public view returns (string memory) {
        return (voters[_vid].addr);
    }
    function getvotefor (uint _vid) public view returns (uint) {
        return (voters[_vid].votefor);
    }
    function getvid (uint _vid) public view returns (uint) {
        return (voters[_vid].vid);
    }
    function getvoteforint (uint _AddressInt) public view returns (uint) {
        return (voters[_AddressInt].votefor);
    }

    //search fake voter
    function getfakevoter (uint _vid) public view returns (string memory) {
        return (fakevoters[_vid].addr);
    }
    function getfakevotefor (uint _vid) public view returns (uint) {
        return (fakevoters[_vid].votefor);
    }
    function getfakevid (uint _vid) public view returns (uint) {
        return (fakevoters[_vid].vid);
    }
}
