const GoalPlan = async (goal_amount, time_frame, month_income, pendingLoan, userTransaction, bankBalance) => {
    try {
        // Calculate total pending loan amount
        let total_pending_loan = 0
        pendingLoan.forEach(loan => {
            total_pending_loan += parseFloat(loan.base_amount)
        })

        // Calculate total expenses from user transactions
        let total_expenses = 0
        userTransaction.forEach(transaction => {
            total_expenses += parseFloat(transaction.amount)
        })

        // Calculate net savings (bank balance - pending loan - total expenses)
        let net_savings = parseFloat(bankBalance) - total_pending_loan - total_expenses

        let interval = null
        let saving_needed_considering_all = null
        let saving_needed_excluding_all = null

        // Calculate daily or monthly savings needed to reach the goal amount
        if (time_frame < 30) {
            interval = "daily"
            saving_needed_considering_all = (goal_amount - net_savings) / time_frame
            saving_needed_excluding_all = goal_amount / time_frame
        } else {
            interval = "monthly"
            let months = time_frame / 30
            saving_needed_considering_all = (goal_amount - net_savings) / months
            saving_needed_excluding_all = goal_amount / months
        }

        // Prepare output in JSON format
        const output = {
            goal_amount: parseFloat(goal_amount),
            time_frame: parseInt(time_frame),
            bank_balance: parseFloat(bankBalance),
            pending_loan: total_pending_loan,
            user_transaction: total_expenses,
            month_income: parseFloat(month_income),
            net_savings: net_savings,
            interval: interval,
            saving_needed_considering_all: saving_needed_considering_all !== null ? parseFloat(saving_needed_considering_all.toFixed(2)) : null, // Round to 2 decimal places
            saving_needed_excluding_all: saving_needed_excluding_all !== null ? parseFloat(saving_needed_excluding_all.toFixed(2)) : null // Round to 2 decimal places
        }

        return output
    } catch (error) {
        console.error("Error calculating goal plan:", error)
        return {
            goal_amount: 0,
            time_frame: 0,
            bank_balance: 0,
            pending_loan: 0,
            user_transaction: 0,
            month_income: 0,
            net_savings: 0,
            saving_needed_considering_all: 0,
            saving_needed_excluding_all: 0,
            interval: null
        }
    }
}

module.exports = GoalPlan
