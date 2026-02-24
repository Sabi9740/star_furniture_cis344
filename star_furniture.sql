-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema star_furniture_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema star_furniture_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `star_furniture_db` DEFAULT CHARACTER SET utf8 ;
USE `star_furniture_db` ;

-- -----------------------------------------------------
-- Table `star_furniture_db`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`Supplier` (
  `supplier_id` INT NULL AUTO_INCREMENT,
  `supplier_name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`supplier_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`FurnitureItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`FurnitureItem` (
  `item_id` INT NULL AUTO_INCREMENT,
  `item_type` VARCHAR(50) NULL,
  `base_price` DECIMAL(10,2) NULL,
  `Supplier_supplier_id` INT NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `fk_FurnitureItem_Supplier1_idx` (`Supplier_supplier_id` ASC) VISIBLE,
  CONSTRAINT `fk_FurnitureItem_Supplier1`
    FOREIGN KEY (`Supplier_supplier_id`)
    REFERENCES `star_furniture_db`.`Supplier` (`supplier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`SupplierMaterial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`SupplierMaterial` (
  `supplier_material_id` INT NULL AUTO_INCREMENT,
  `supplier_id` INT NOT NULL,
  `material_id` INT NOT NULL,
  `supplier_unit_cost` DECIMAL(10,2) NULL,
  `lead_time_days` INT NULL,
  PRIMARY KEY (`supplier_material_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`Supplier_copy1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`Supplier_copy1` (
  `supplier_id` INT NULL AUTO_INCREMENT,
  `supplier_name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  `SupplierMaterial_supplier_material_id` INT NOT NULL,
  PRIMARY KEY (`supplier_id`, `SupplierMaterial_supplier_material_id`),
  INDEX `fk_Supplier_copy1_SupplierMaterial1_idx` (`SupplierMaterial_supplier_material_id` ASC) VISIBLE,
  CONSTRAINT `fk_Supplier_copy1_SupplierMaterial1`
    FOREIGN KEY (`SupplierMaterial_supplier_material_id`)
    REFERENCES `star_furniture_db`.`SupplierMaterial` (`supplier_material_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`Material`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`Material` (
  `material_id` INT NULL AUTO_INCREMENT,
  `material_name` VARCHAR(100) NOT NULL,
  `qty_on_hand` INT NULL DEFAULT 0,
  `reorder_level` INT NULL DEFAULT 0,
  `Supplier_copy1_supplier_id` INT NOT NULL,
  PRIMARY KEY (`material_id`),
  INDEX `fk_Material_Supplier_copy11_idx` (`Supplier_copy1_supplier_id` ASC) VISIBLE,
  CONSTRAINT `fk_Material_Supplier_copy11`
    FOREIGN KEY (`Supplier_copy1_supplier_id`)
    REFERENCES `star_furniture_db`.`Supplier_copy1` (`supplier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`Payment` (
  `payment_id` INT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `payment_date` DATE NULL,
  `amount` DECIMAL(10,2) NULL,
  `method` VARCHAR(30) NULL,
  `status` VARCHAR(20) NULL DEFAULT 'RECEIVED',
  `Material_material_id` INT NOT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_Payment_copy1_Material1_idx` (`Material_material_id` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_copy1_Material1`
    FOREIGN KEY (`Material_material_id`)
    REFERENCES `star_furniture_db`.`Material` (`material_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`MaterialUsage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`MaterialUsage` (
  `usage_id` INT NULL AUTO_INCREMENT,
  `design_id` INT NOT NULL,
  `material_id` INT NOT NULL,
  `qty_used` INT NULL,
  `Payment_copy1_payment_id` INT NOT NULL,
  PRIMARY KEY (`usage_id`),
  INDEX `fk_MaterialUsage_Payment_copy11_idx` (`Payment_copy1_payment_id` ASC) VISIBLE,
  CONSTRAINT `fk_MaterialUsage_Payment_copy11`
    FOREIGN KEY (`Payment_copy1_payment_id`)
    REFERENCES `star_furniture_db`.`Payment` (`payment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`OrderItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`OrderItem` (
  `order_item_id` INT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `quantity` INT NULL DEFAULT 1,
  `unit-price` DECIMAL(10,2) NULL,
  `line_total` DECIMAL(10,2) NULL,
  `MaterialUsage_usage_id` INT NOT NULL,
  PRIMARY KEY (`order_item_id`),
  INDEX `fk_OrderItem_MaterialUsage1_idx` (`MaterialUsage_usage_id` ASC) VISIBLE,
  CONSTRAINT `fk_OrderItem_MaterialUsage1`
    FOREIGN KEY (`MaterialUsage_usage_id`)
    REFERENCES `star_furniture_db`.`MaterialUsage` (`usage_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`Order` (
  `order_id` INT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `order_date` DATE NOT NULL,
  `due_date` DATE NOT NULL,
  `status` VARCHAR(30) NULL DEFAULT 'NEW',
  `total_amount` DECIMAL(10,2) NULL DEFAULT 0.00,
  `FurnitureItem_item_id` INT NOT NULL,
  `OrderItem_order_item_id` INT NOT NULL,
  PRIMARY KEY (`order_id`, `FurnitureItem_item_id`, `OrderItem_order_item_id`),
  INDEX `fk_Order_FurnitureItem1_idx` (`FurnitureItem_item_id` ASC) VISIBLE,
  INDEX `fk_Order_OrderItem1_idx` (`OrderItem_order_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_Order_FurnitureItem1`
    FOREIGN KEY (`FurnitureItem_item_id`)
    REFERENCES `star_furniture_db`.`FurnitureItem` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_OrderItem1`
    FOREIGN KEY (`OrderItem_order_item_id`)
    REFERENCES `star_furniture_db`.`OrderItem` (`order_item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`Customer` (
  `Customer_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `address` VARCHAR(255) NULL,
  `Order_order_id` INT NOT NULL,
  `Order_order_id2` INT NOT NULL,
  PRIMARY KEY (`Customer_id`, `Order_order_id`, `Order_order_id2`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_Customer_Order1_idx` (`Order_order_id2` ASC) VISIBLE,
  CONSTRAINT `fk_Customer_Order1`
    FOREIGN KEY (`Order_order_id2`)
    REFERENCES `star_furniture_db`.`Order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`DesignSpec`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`DesignSpec` (
  `design_id` INT NULL AUTO_INCREMENT,
  `order_item_id` INT NOT NULL,
  `dimensions` VARCHAR(100) NULL,
  `finish_color` VARCHAR(50) NULL,
  `notes` VARCHAR(255) NULL,
  `revision_no` INT NULL DEFAULT 1,
  `approval_status` VARCHAR(20) NULL DEFAULT 'PENDING',
  `approved_date` DATE NULL,
  `MaterialUsage_usage_id` INT NOT NULL,
  `Material_material_id` INT NOT NULL,
  PRIMARY KEY (`design_id`, `MaterialUsage_usage_id`, `Material_material_id`),
  INDEX `fk_DesignSpec_MaterialUsage1_idx` (`MaterialUsage_usage_id` ASC) VISIBLE,
  INDEX `fk_DesignSpec_Material1_idx` (`Material_material_id` ASC) VISIBLE,
  CONSTRAINT `fk_DesignSpec_MaterialUsage1`
    FOREIGN KEY (`MaterialUsage_usage_id`)
    REFERENCES `star_furniture_db`.`MaterialUsage` (`usage_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DesignSpec_Material1`
    FOREIGN KEY (`Material_material_id`)
    REFERENCES `star_furniture_db`.`Material` (`material_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`WorkOrder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`WorkOrder` (
  `work_order_id` INT NULL AUTO_INCREMENT,
  `order_item_id` INT NOT NULL,
  `assigned_to` INT NOT NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `status` VARCHAR(30) NULL DEFAULT 'NOT_STARTED',
  `OrderItem_order_item_id` INT NOT NULL,
  `MaterialUsage_usage_id` INT NOT NULL,
  PRIMARY KEY (`work_order_id`),
  INDEX `fk_WorkOrder_OrderItem1_idx` (`OrderItem_order_item_id` ASC) VISIBLE,
  INDEX `fk_WorkOrder_MaterialUsage1_idx` (`MaterialUsage_usage_id` ASC) VISIBLE,
  CONSTRAINT `fk_WorkOrder_OrderItem1`
    FOREIGN KEY (`OrderItem_order_item_id`)
    REFERENCES `star_furniture_db`.`OrderItem` (`order_item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_WorkOrder_MaterialUsage1`
    FOREIGN KEY (`MaterialUsage_usage_id`)
    REFERENCES `star_furniture_db`.`MaterialUsage` (`usage_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `star_furniture_db`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `star_furniture_db`.`Employee` (
  `employee_id` INT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NULL,
  `last_name` VARCHAR(50) NULL,
  `role` VARCHAR(30) NULL,
  `phone` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  `Payment_payment_id` INT NOT NULL,
  `Payment_Customer_Customer_id` INT NOT NULL,
  `Payment_Customer_Order_order_id` INT NOT NULL,
  `Payment_Customer_Order_order_id2` INT NOT NULL,
  `WorkOrder_work_order_id` INT NOT NULL,
  `Payment_copy1_payment_id` INT NOT NULL,
  `Material_material_id` INT NOT NULL,
  PRIMARY KEY (`employee_id`, `Payment_payment_id`, `Payment_Customer_Customer_id`, `Payment_Customer_Order_order_id`, `Payment_Customer_Order_order_id2`, `Payment_copy1_payment_id`, `Material_material_id`),
  INDEX `fk_Employee_WorkOrder1_idx` (`WorkOrder_work_order_id` ASC) VISIBLE,
  INDEX `fk_Employee_Payment_copy11_idx` (`Payment_copy1_payment_id` ASC) VISIBLE,
  INDEX `fk_Employee_Material1_idx` (`Material_material_id` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_WorkOrder1`
    FOREIGN KEY (`WorkOrder_work_order_id`)
    REFERENCES `star_furniture_db`.`WorkOrder` (`work_order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_Payment_copy11`
    FOREIGN KEY (`Payment_copy1_payment_id`)
    REFERENCES `star_furniture_db`.`Payment` (`payment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_Material1`
    FOREIGN KEY (`Material_material_id`)
    REFERENCES `star_furniture_db`.`Material` (`material_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
