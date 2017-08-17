contract Payroll {

    address public owner;
    uint public nextEmpolyeeID;
    struct Employee {
        uint employeeId;
        uint wages;
        uint balance;
    }

    mapping (address => Employee) employees;

    modifier onlyOwner {
        if (msg.sender==owner)
        _
    }

    function Payroll() {
        owner = msg.sender;
        addEmployee(msg.sender, 0);
    }

    // allows function initiator to withdraw funds if they're an employee equal to their balance
    function withdrawPayroll() returns (bool _success) {
        uint empBalance = employees[msg.sender].balance;
        if (empBalance > 0 && this.balance >= empBalance) {
                if (msg.sender.send(empBalance)){
                    employees[msg.sender].balance = 0;
                    return true;
            }
        }
        return false;
    }

    // function for getting an ID by address if needed
    function getEmployeeIdByAddress(address _employee) returns (uint _employeeId) {
        return employees[_employee].employeeId;
    }

    /* OWNER ONLY FUNCTIONS */
    // add an employee given an address and wages
    function addEmployee(address _employee, uint _wages) onlyOwner returns (bool _success) {
        nextEmpolyeeID++;
        employees[_employee].employeeId=nextEmpolyeeID;
        employees[_employee].wages=_wages;
        //balance is 0 by default
        return true;
    }

    function removeEmployee(address _employee) onlyOwner returns (bool _success) {
        employees[_employee].wages=0;
        employees[_employee].employeeId=0;
        return true;
    }

    // pay the employee their wages given an employee ID
    function payEmployee(address _employeeId) onlyOwner returns (bool _success) {
            employees[_employeeId].balance += employees[_employeeId].wages;
            //keep their balance so they can escape with their dignity
            return true;
    }

    // modify the employee wages given an employeeId and a new wage
    function modifyEmployeeWages(address _employeeId, uint _newWage) onlyOwner returns (bool _success) {
        employees[_employeeId].wages = _newWage;
        return true;
    }
}