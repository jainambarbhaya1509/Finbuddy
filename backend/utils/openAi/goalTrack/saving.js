const { pool } = require("../../../config/dbConfig");

const fetchLoan = async (userId) => {
  try {
    const { rows } = await pool.query(
      'SELECT * FROM loan JOIN loan_type ON loan.loan_type_id = loan_type.id WHERE loan.account_id = $1',
      [userId]
    );
    return rows;
  } catch (error) {
    console.error("Error fetching loan data:", error);
    throw error;
  }
};

const fetchTransaction = async (userId) => {
  try {
    const { rows } = await pool.query(
      'SELECT * FROM transaction WHERE account_id = $1',
      [userId]
    );
    return rows;
  } catch (error) {
    console.error("Error fetching transaction data:", error);
    throw error;
  }
};

const fetchBalance = async (userId) => {
  try {
    const { rows } = await pool.query(
      'SELECT balance FROM account WHERE id = $1',
      [userId]
    );
    return rows[0].balance;
  } catch (error) {
    console.error("Error fetching balance data:", error);
    throw error;
  }
};

const GoalPlan = async (goal_amount, time_frame, userId, month_income) => {
  try {
    // Retrieve user data
    const pendingLoan = await fetchLoan(userId);
    const userTransaction = await fetchTransaction(userId);
    const bankBalance = await fetchBalance(userId);

    // Calculate total pending loan amount
    let total_pending_loan = 0;
    pendingLoan.forEach(loan => {
      total_pending_loan += parseFloat(loan.base_amount);
    });

    // Calculate total expenses from user transactions
    let total_expenses = 0;
    userTransaction.forEach(transaction => {
      total_expenses += parseFloat(transaction.amount);
    });

    // Calculate net savings (bank balance - pending loan)
    let net_savings = parseInt(bankBalance) - total_pending_loan;

    // Calculate monthly savings needed to reach the goal amount
    let months = time_frame / 30; // Convert days to months approximately
    let monthly_savings_needed = (goal_amount - net_savings) / months;

    // Prepare output in JSON format
    const output = {
      goal_amount: goal_amount,
      time_frame: time_frame,
      bank_balance: parseInt(bankBalance),
      pending_loan: total_pending_loan,
      user_transaction: total_expenses,
      month_income: month_income,
      net_savings: net_savings,
      monthly_savings_needed: parseFloat(monthly_savings_needed.toFixed(2)) // Round to 2 decimal places
    };

    return output;
  } catch (error) {
    console.error("Error calculating goal plan:", error);
    return {
      goal_amount: 0,
      time_frame: 0,
      bank_balance: 0,
      pending_loan: 0,
      user_transaction: 0,
      month_income: 0,
      net_savings: 0,
      monthly_savings_needed: 0
    };
  }
};

module.exports = GoalPlan;
