# Stage 4 – PL/pgSQL Programming

This stage adds business logic to the integrated database created in Stage 3.
The implementation includes functions, procedures, triggers, and main SQL programs that demonstrate their execution.

## Files

1. `01_function_calculate_customer_marketing_score.sql`  
   Calculates a marketing score for a customer based on purchases, campaign participation, campaign-related sales, and loyalty level.

2. `02_function_calculate_employee_bonus.sql`  
   Calculates an employee bonus according to total sales, number of sales, and sales tiers.

3. `03_procedure_apply_campaign_discount.sql`  
   Applies an active campaign promotion to all sales belonging to a selected campaign and recalculates sale totals.

4. `04_procedure_restock_low_inventory.sql`  
   Restocks inventory rows whose quantity is below the minimum stock level.

5. `05_trigger_validate_sale_item.sql`  
   Validates sale item data before insert or update, prevents invalid discounts, and calculates final item price.

6. `06_trigger_update_inventory_after_sale_item.sql`  
   Automatically updates inventory quantity after sale item insert or update.

7. `07_main_program_customer_campaign.sql`  
   Demonstrates one function and one procedure: customer marketing score and campaign discount application.

8. `08_main_program_employee_inventory.sql`  
   Demonstrates one function and one procedure: employee bonus calculation and inventory restocking.

9. `09_trigger_demo.sql`  
   Demonstrates the triggers by inserting or updating a sale item and showing the inventory change.

10. `AlterTable.sql`  
    Documents that no schema changes were required.

## Notes for running

Run files 1-6 first in pgAdmin.  
Then run files 7-9 for proof screenshots.

The main programs currently end with `ROLLBACK` for safe testing.  
For final screenshots where a permanent database update is needed, replace `ROLLBACK` with `COMMIT`.

## Main business logic

The functions and procedures are not simple SELECT queries. They include business logic such as:

- customer marketing scoring
- employee bonus calculation by sales tiers
- campaign discount application
- automatic inventory restocking
- sale item validation
- automatic stock updates

The implementation uses PL/pgSQL elements such as:

- explicit cursor
- implicit cursor
- loops
- records
- conditions
- DML commands
- exception handling
- triggers on update
