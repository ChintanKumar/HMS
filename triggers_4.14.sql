   -- 1. Trigger to prevent the quantity of a medicine from being reduced if it has expired.
   
   DELIMITER //
   CREATE TRIGGER PreventExpiredMedicineDispensing
   BEFORE UPDATE ON MedicineInventory
   FOR EACH ROW
   BEGIN
       IF NEW.quantity < OLD.quantity AND NEW.expiry_date < CURDATE() THEN
           SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Cannot dispense expired medicine.';
       END IF;
   END //
   DELIMITER ;

   UPDATE MedicineInventory
   SET
       quantity = quantity - 5  -- Attempt to dispense 5 units
   WHERE
       medicine_id = 301;
       
-- 2. Trigger to automatically update the payment_status in the BillingAndPayments table.

DELIMITER //
   CREATE TRIGGER UpdatePaymentStatus
   AFTER UPDATE ON BillingAndPayments
   FOR EACH ROW
   BEGIN
       IF NEW.paid_amount >= NEW.total_amount THEN
           UPDATE BillingAndPayments
           SET
               payment_status = 'Paid'
           WHERE
               billing_id = NEW.billing_id;
       ELSEIF NEW.paid_amount > 0 AND NEW.paid_amount < NEW.total_amount THEN
           UPDATE BillingAndPayments
           SET
               payment_status = 'Partially Paid'
           WHERE
               billing_id = NEW.billing_id;
       ELSE
           UPDATE BillingAndPayments
           SET
               payment_status = 'Pending'
           WHERE
               billing_id = NEW.billing_id;
       END IF;
   END //
   DELIMITER ;
   
      UPDATE BillingAndPayments
   SET
       paid_amount = 30.00
   WHERE
       billing_id = 102;
       
SELECT * FROM BillingAndPayments WHERE billing_id = 102;