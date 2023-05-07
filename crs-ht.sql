/*
SQLyog Community v13.1.9 (64 bit)
MySQL - 8.0.31 : Database - ht_wms
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`ht_wms` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ht_wms`;

/*Table structure for table `sys_department` */

DROP TABLE IF EXISTS `sys_department`;

CREATE TABLE `sys_department` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门编号',
  `department_name` varchar(50) DEFAULT NULL COMMENT '部门名称',
  `phone` varchar(50) DEFAULT NULL COMMENT '部门电话',
  `address` varchar(255) DEFAULT NULL COMMENT '部门地址',
  `pid` bigint NOT NULL COMMENT '所属部门编号',
  `parent_name` varchar(50) NOT NULL COMMENT '所属部门名称',
  `order_num` int DEFAULT NULL COMMENT '排序',
  `is_delete` tinyint DEFAULT NULL COMMENT '是否删除(0-未删除 1-已删除)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

/*Data for the table `sys_department` */

insert  into `sys_department`(`id`,`department_name`,`phone`,`address`,`pid`,`parent_name`,`order_num`,`is_delete`) values 
(1,'广州信息公司','11111111','广州天河区',0,'顶级部门',1,0),
(2,'软件技术部','22222222','广州天河区',0,'广州信息公司',1,0),
(3,'人事管理部','33333333','广州天河区',1,'广州信息公司',1,0),
(4,'市场管理部','44444444','广州天河区',1,'广州信息公司',1,0),
(5,'软件研发部','55555555','广州天河区',1,'广州信息公司',1,0),
(6,'java技术部','21111111','广州天河区',2,'软件技术部',1,0);

/*Table structure for table `sys_permission` */

DROP TABLE IF EXISTS `sys_permission`;

CREATE TABLE `sys_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限编号',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '权限名称',
  `parent_id` bigint DEFAULT NULL COMMENT '父权限ID',
  `parent_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '父权限名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '授权标识符',
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '路由地址',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '路由名称',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '授权路径',
  `type` tinyint DEFAULT NULL COMMENT '权限类型(0-目录 1-菜单 2-按钮)',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '图标',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  `order_num` int DEFAULT '0' COMMENT '排序',
  `is_delete` tinyint DEFAULT NULL COMMENT '是否删除(0-未删除，1-已删除)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3;

/*Data for the table `sys_permission` */

insert  into `sys_permission`(`id`,`label`,`parent_id`,`parent_name`,`code`,`path`,`name`,`url`,`type`,`icon`,`create_time`,`update_time`,`remark`,`order_num`,`is_delete`) values 
(1,'系统管理',0,'顶级菜单','sys:manager','/system','system','/system/system',0,NULL,NULL,NULL,NULL,0,NULL),
(2,'部门管理',1,'系统管理','sys:department','/department','department','/system/department/department',1,NULL,NULL,NULL,NULL,0,NULL),
(3,'新增',2,'部门管理','sys:department:add',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(4,'修改',2,'部门管理','sys:department:edit',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(5,'删除',2,'部门管理','sys:department:delete',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(6,'用户管理',1,'系统管理','sus:user','/userList','userList','/system/user/userList',1,NULL,NULL,NULL,NULL,0,NULL),
(7,'新增',3,'用户管理','sus:user:add',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(8,'修改',3,'用户管理','sus:user:edit',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(9,'删除',3,'用户管理','sus:user:delete',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(10,'角色管理',1,'系统管理','sys:role','/roleList','roleList','/system/role/roleList',1,NULL,NULL,NULL,NULL,0,NULL),
(11,'新增',4,'角色管理','sys:role:add',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(12,'修改',4,'角色管理','sys:role:edit',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(13,'删除',4,'角色管理','sys:role:delete',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(14,'菜单管理',1,'系统管理','sys:menu','/menuList','menuList','/system/menu/menuList',1,NULL,NULL,NULL,NULL,0,NULL),
(15,'新增',5,'菜单管理','sys:menu:add',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(16,'修改',5,'菜单管理','sys:menu:edit',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL),
(17,'删除',5,'菜单管理','sys:menu:delete',NULL,NULL,NULL,2,NULL,NULL,NULL,NULL,0,NULL);

/*Table structure for table `sys_role` */

DROP TABLE IF EXISTS `sys_role`;

CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色编号',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色编码',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色名称',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  `is_delete` tinyint DEFAULT NULL COMMENT '是否删除(0-未删除，1-已删除)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

/*Data for the table `sys_role` */

insert  into `sys_role`(`id`,`role_code`,`role_name`,`create_user`,`create_time`,`update_time`,`remark`,`is_delete`) values 
(1,'role_system','系统管理员',1,'2023-04-19 17:38:15','2023-04-19 17:38:18',NULL,0),
(2,'role_admin','超级管理员',2,'2023-04-19 17:39:09','2023-04-19 17:39:11',NULL,0),
(3,'role_resource','资料管理员',2,'2023-04-19 17:39:50','2023-04-19 17:39:53',NULL,0);

/*Table structure for table `sys_role_permission` */

DROP TABLE IF EXISTS `sys_role_permission`;

CREATE TABLE `sys_role_permission` (
  `role_id` bigint NOT NULL COMMENT '角色编号',
  `permission_id` bigint NOT NULL COMMENT '权限编号',
  KEY `fk_role` (`role_id`),
  KEY `fk_permission` (`permission_id`),
  CONSTRAINT `fk_permission` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`),
  CONSTRAINT `fk_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*Data for the table `sys_role_permission` */

insert  into `sys_role_permission`(`role_id`,`permission_id`) values 
(1,1),
(1,2),
(1,6),
(1,10),
(1,14);

/*Table structure for table `sys_user` */

DROP TABLE IF EXISTS `sys_user`;

CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `username` varchar(50) NOT NULL COMMENT '登录名称(用户名)',
  `password` varchar(100) NOT NULL COMMENT '登录密码',
  `is_account_non_expired` tinyint NOT NULL COMMENT '帐户是否过期(1-未过期，0-已过期)',
  `is_account_non_locked` tinyint NOT NULL COMMENT '帐户是否被锁定(1-未过期，0-已过期)',
  `is_credentials_non_expired` tinyint NOT NULL COMMENT '密码是否过期(1-未过期，0-已过期)',
  `is_enabled` tinyint NOT NULL COMMENT '帐户是否可用(1-可用，0-禁用)',
  `real_name` varchar(50) NOT NULL COMMENT '真实姓名',
  `nick_name` varchar(50) DEFAULT NULL COMMENT '昵称',
  `department_id` bigint DEFAULT NULL COMMENT '所属部门ID',
  `department_name` varchar(50) DEFAULT NULL COMMENT '所属部门名称',
  `gender` tinyint NOT NULL COMMENT '性别(0-男，1-女)',
  `phone` varchar(50) NOT NULL COMMENT '电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '用户头像',
  `is_admin` tinyint DEFAULT '0' COMMENT '是否是管理员(1-管理员)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否删除(0-未删除，1-已删除)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

/*Data for the table `sys_user` */

insert  into `sys_user`(`id`,`username`,`password`,`is_account_non_expired`,`is_account_non_locked`,`is_credentials_non_expired`,`is_enabled`,`real_name`,`nick_name`,`department_id`,`department_name`,`gender`,`phone`,`email`,`avatar`,`is_admin`,`create_time`,`update_time`,`is_delete`) values 
(1,'admin','$2a$10$UKbaw9IubUjvfL3XTDqXFOYzGf3ktmJxt3nbE1EsfzfGcoHaqk8r.',1,1,1,1,'超级管理员','超级管理员',NULL,NULL,1,'11111111',NULL,'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif',1,NULL,NULL,0),
(2,'zhaolong','$2a$10$VcNUfQ/0cN.2OtDJt4tgnOLgwtyL0VdDKbgMN/ptbh6gN63eMEqUa',1,1,1,1,'管理员','管理员',NULL,NULL,0,'11111111',NULL,NULL,0,NULL,NULL,0),
(3,'张三','$2a$10$VcNUfQ/0cN.2OtDJt4tgnOLgwtyL0VdDKbgMN/ptbh6gN63eMEqUa',1,1,1,1,'普通用户','普通用户',NULL,NULL,1,'11111111',NULL,NULL,0,NULL,NULL,0),
(4,'李四','$2a$10$VcNUfQ/0cN.2OtDJt4tgnOLgwtyL0VdDKbgMN/ptbh6gN63eMEqUa',1,1,1,1,'匿名用户','匿名用户',NULL,NULL,1,'11111111',NULL,NULL,0,NULL,NULL,0);

/*Table structure for table `sys_user_role` */

DROP TABLE IF EXISTS `sys_user_role`;

CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户编号',
  `role_id` bigint NOT NULL COMMENT '角色编号',
  KEY `fk_userid` (`user_id`),
  KEY `fk_roleid` (`role_id`),
  CONSTRAINT `fk_roleid` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`),
  CONSTRAINT `fk_userid` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Data for the table `sys_user_role` */

insert  into `sys_user_role`(`user_id`,`role_id`) values 
(1,1),
(1,2),
(2,3),
(1,3);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
