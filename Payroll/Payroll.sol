contract Payroll {
    // define variables
    address public CompanyOwner;
    
    uint employeeId;
    
    // create Employee object
    struct Employee {
        uint employeeId;
        address employeeAddress;
        uint wages;
        uint balance;
    }
    
    // employees contain Employee
    Employee[] public employees;
    
    // run this on contract creation just once
    function Payroll() {
        // make CompanyOwner the person who deploys the contract
        CompanyOwner = msg.sender;
        employeeId = 0;
        // add the company owner as an employee with a wage of 0
        AddEmployee(msg.sender, 0);
    }
    
    // function for checking number of employees
    function NumberOfEmployees() returns (uint _numEmployees) {
        return employeeId;
    }
    
    // allows function initiator to withdraw funds if they're an employee equal to their balance
    function WithdrawPayroll() returns (bool _success) {
        var employeeId = GetCurrentEmployeeId();
        if (employeeId != 999999) {
            // they are an employee
            if (employees[employeeId].balance > 0) {
                // if they have a balance
                if (this.balance >= employees[employeeId].balance) {
                    // if the balance of the contract is greater than or equal to employee balance 
                    // then send them the money from the contract and set balance back to 0
                    msg.sender.send(employees[employeeId].balance);
                    employees[employeeId].balance = 0;
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
    
    function GetCurrentEmployeeId() returns (uint _employeeId) {
        // loop through employees
        for (var i = 0; i < employees.length; i++) {
            // if the initiator of the function's address exists in the employeeAddress area of an Employee, return ID
            if (msg.sender == employees[i].employeeAddress) {
                return employees[i].employeeId;
            }
        }
        return 999999;
    }
    
    // function for getting an ID by address if needed
    function GetEmployeeIdByAddress(address _employee) returns (uint _employeeId) {
        for (var i = 0; i < employees.length; i++) {
            if (_employee == employees[i].employeeAddress) {
                return employees[i].employeeId;
            }
        }
        return 999999;
    }
    
    
    /* OWNER ONLY FUNCTIONS */
    // add an employee given an address and wages
    function AddEmployee(address _employee, uint _wages) returns (bool _success) {
        if (msg.sender != CompanyOwner) {
            return false;
        } else {
            employees.push(Employee(employeeId, _employee, _wages, 0));
            employeeId++;
            return true;
        }
    }
    
    // pay the employee their wages given an employee ID
    function PayEmployee(uint _employeeId) returns (bool _success) {
        if (msg.sender != CompanyOwner) {
            return false;
        } else {
            // TODO: need to figure out how to check to make sure employees[_employeeId] exists
            employees[_employeeId].balance += employees[_employeeId].wages;
            return true;
        }
    }
    
    // modify the employee wages given an employeeId and a new wage
    function ModifyEmployeeWages(uint _employeeId, uint _newWage) returns (bool _success) {
        if (msg.sender != CompanyOwner) {
            return false;
        } else {
            // TODO: need to figure out how to check to make sure employees[_employeeId] exists
            // change employee wages to new wage
            employees[_employeeId].wages = _newWage;
            return true;
        }
    }
    
    // check how much money is in the contract
    function CheckContractBalance() returns (uint _balance) {
        return this.balance;
    }
    
}