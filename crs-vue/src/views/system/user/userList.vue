<template>
    <el-container :style="{height: containerHeight + 'px'}">
      <!-- 左侧菜单树 -->
      <el-aside style="padding: 10px 0 0 0; background: #fff; border-right: #dfe6ec" width="220px">
        <el-tree
          style="font-size: 14px"
          ref="leftTree"
          :data="deptList"
          node-key="id"
          :props="defaultProps"
          default-expand-all
          empty-text="暂无数据"
          :show-checkbox="false"
          :highlight-current="true"
          :expand-on-click-node="false"
          @node-click="handleNodeClick">
          <div class="custom-tree-node" slot-scope="{node, data}">
            <div>
              <span v-if="data.children.length == 0">
                <i class="el-icon-document"></i>
              </span>
              <span v-else @click.stop="changeIcon(data)">
                <svg-icon v-if="data.open" icon-class="add-s"/>
                <svg-icon v-else icon-class="sub-s"/>
              </span>
              <span style="margin-left: 3px">{{node.label}}</span>
            </div>
          </div>
        </el-tree>
      </el-aside>
      <!-- 右侧列表 -->
      <el-main>
        <el-form ref="searchForm" :model="searchModel" label-width="80px" :inline="true" size="small">
          <el-form-item>
            <el-input v-model="searchModel.username" placeholder="请输入用户名"/>
          </el-form-item>
          <el-form-item>
            <el-input v-model="searchModel.realName" placeholder="请输入用户名"/>
          </el-form-item>
          <el-form-item>
            <el-input v-model="searchModel.phone" placeholder="请输入联系电话"/>
          </el-form-item>
          <el-form-item>
            <el-button icon="el-icon-search" type="primary"
                         @click="search(departmentId, pageNo, pageSize)">查询</el-button>
            <el-button icon="el-icon-delete" @click="resetValue()">重置</el-button>
            <el-button icon="el-icon-plus" type="primary"
                       @click="openAddWindow()">新增</el-button>
          </el-form-item>
        </el-form>
        <el-table
          :data="userList" :height="tableHeight" border stripe
          style="width: 100%; margin-bottom: 10px">
          <el-table-column  prop="username" label="用户名" ></el-table-column>
          <el-table-column prop="realName" label="姓名" ></el-table-column>
          <el-table-column prop="departmentName" label="所属部门" ></el-table-column>
          <el-table-column prop="phone" label="电话" ></el-table-column>
          <el-table-column prop="email" label="邮箱" ></el-table-column>
          <el-table-column align="center" label="操作" width="290">
            <template slot-scope="scope">
              <el-button icon="el-icon-edit" type="primary" size="mini"
                         @click="handleEdit(scope.row)">修改</el-button>
              <el-button icon="el-icon-delete" type="danger" size="mini"
                         @click="handleDelete(scope.row)">删除</el-button>
              <el-button icon="el-icon-setting" type="primary" size="mini"
                         @click="assignRole(scope.row)">分配角色</el-button>
            </template>
          </el-table-column>
        </el-table>
<!--        新增和修改-->
        <system-dialog
          :title="userDialog.title"
          :visible="userDialog.visible"
          :width="userDialog.width"
          :height="userDialog.height"
          @onClose="onClose()"
          @onConfirm="onConfirm()"
        >
          <div slot="content">
            <el-form :model="user" ref="userForm" :rules="rules" label-width="80px" :inline="true" size="small">
              <el-form-item label="用户名" prop="username">
                <el-input v-model="user.username"></el-input>
              </el-form-item>
              <el-form-item label="密码" v-if="user.id === ''" prop="password">
                <el-input type="password" v-model="user.password"></el-input>
              </el-form-item>
              <el-form-item label="所属部门" prop="departmentName">
                <el-input v-model="user.departmentName" :readonly="true" @click.native="selectDepartment()"></el-input>
              </el-form-item>
              <el-form-item label="姓名" prop="realName">
                <el-input v-model="user.realName"></el-input>
              </el-form-item>
              <el-form-item label="电话" prop="phone">
                <el-input v-model="user.phone"></el-input>
              </el-form-item>
              <el-form-item label="昵称" >
                <el-input v-model="user.nickName"></el-input>
              </el-form-item>
              <el-form-item label="邮箱" >
                <el-input v-model="user.email"></el-input>
              </el-form-item>
              <el-form-item label="性别" prop="gender">
                <el-radio-group v-model="user.gender">
                  <el-radio :label="0">男</el-radio>
                  <el-radio :label="1">女</el-radio>
                </el-radio-group>
              </el-form-item>

            </el-form>
          </div>
        </system-dialog>
<!--        所属部门-->
        <system-dialog
          :title="parentDialog.title"
          :visible="parentDialog.visible"
          :width="parentDialog.width"
          :height="parentDialog.height"
          @onClose="onParentClose()"
          @onConfirm="onParentConfirm()"
        >
          <div slot="content">
            <el-tree
              ref="parentTree"
              :data="parentList"
              default-expand-all
              node-key="id"
              :props="parentProps"
              :show-checkbox="false"
              :highlight-current="true"
              :expand-on-click-node="false"
              @node-click="parentClick">
              <div class="custom-tree-node" slot-scope="{node, data}">
                <!-- 判断当前节点是否有子节点-->
                <span v-if="data.children.length === 0" >
                  <i class="el-icon-document"></i>
                </span>
                <span v-else @click.stop="openParentBtn(data)">
                  <svg-icon v-if="data.open" icon-class="el-icon-plus"></svg-icon>
                  <svg-icon v-else icon-class="el-icon-minus"></svg-icon>
                </span>
                <span style="margin-left: 3px" >{{node.label}}</span>
              </div>
            </el-tree>
          </div>
        </system-dialog>
<!--分配角色-->
        <system-dialog
          :title="assignDialog.title"
          :visible="assignDialog.visible"
          :width="assignDialog.width"
          :height="assignDialog.height"
          @onClose="onAssignClose()"
          @onConfirm="onAssignConfirm()"
        >
          <div slot="content">
            <el-table
              ref="assignRoleTable"
              :data="assignRoleList"
              border
              stripe
              :height="assignHeight"
              style="width: 100%; margin-bottom: 10px"
              @selection-change="handleSelectionChange"
            >
              <el-table-column type="selection" width="55" align="center"></el-table-column>
              <el-table-column prop="roleCode" label="角色编码"/>
              <el-table-column prop="roleName" label="角色名称"/>
              <el-table-column prop="remark" label="角色备注"/>
            </el-table>
            <el-pagination
              @size-change="assignSizeChange"
              @current-change="assignCurrentChange"
              :current-page.sync="roleVo.pageNo"
              :page-sizes="[10,15,20,25,30]"
              :page-size="roleVo.pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="roleVo.total"
              background
            >
            </el-pagination>
          </div>
        </system-dialog>
<!--        分页-->
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNo"
          :page-sizes="[10,15,20,25,30]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
        </el-pagination>
      </el-main>
    </el-container>
</template>

<script>

import departmentApi from '@/api/department'
import userApi from '@/api/user';
import SystemDialog from "@/components/system/SystemDialog";
export default {
  name: "userList",
  components: {
    SystemDialog
  },
  data() {
    let validatePhone = (rule, value, callback) => {
      if (!value) {
        callback(new Error("请输入手机号码"));
      }else if (!/^1[3456789]\d{9}$/.test(value)){
        callback(new Error("手机号格式不正确"));
      }else{
        callback();
      }
    };
    return{
      containerHeight: 0,
      deptList: [],
      userList: [],
      tableHeight: 0,
      departmentId: "",
      pageNo:1,
      pageSize:10,
      total: null,
      defaultProps: {
        children: 'children',
        label: 'departmentName',
      },
      searchModel:{
        username: "",
        realName: "",
        phone: "",
        departmentId: "",
        pageNo:1,
        pageSize:10,
      },
      userDialog:{
        title: "",
        visible: false,
        width: 610,
        height: 260,
      },
      parentDialog:{
        title: "选择所属部门",
        visible: false,
        width: 300,
        height: 450,
      },
      parentList: [],
      parentProps: {
        children: "children",
        label: "departmentName"
      },
      user: {
        id: "",
        departmentId:"",
        departmentName: "",
        email: "",
        realName:"",
        phone: "",
        nickName:"",
        username:"",
        password:"",
        gender:"",
        avatar:"",
      },
      rules: {
        departmentName: [{ required: true, message: '请选择所属部门', trigger: 'change' }],
        realName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
        phone: [{trigger: 'blur', validator: validatePhone}],
        username: [{ required: true, message: '请输入登录名', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
        gender: [{ required: true, message: '请选择性别', trigger: 'change' }],

      },
      assignDialog: {
        title: "",
        visible: false,
        width: 800,
        height: 410,
      },
      roleVo: {
        pageNo: 1,
        pageSize: 10,
        userId: "",
        total: null,
      },
      assignRoleList: [],
      assignHeight: 0,
      selectIds: [],
      selectedUserId: "",
    };
  },
  created() {
    this.getDeptList();
    this.search(this.departmentId)
  },
  mounted() {
    this.$nextTick(()=>{
      this.containerHeight = window.innerHeight-85;
      this.tableHeight = window.innerHeight-220;
      this.assignHeight = window.innerHeight-350;
    })
  },
  methods:{
    /**
     * 查询部门列表
     * @returns {Promise<void>}
     */
    async getDeptList(){
      //发送查询请求
      let res = await departmentApi.getDepartmentList(null);

      if (res.success) {
        this.deptList = res.data;
        this.$nextTick(() => {
          const firstNode = document.querySelector(".el-tree-node");
          firstNode.click();
        })
      }
    },
    /**
     * 点击树节点加减号时触发
     * @param data
     */
    changeIcon(data) {
      //修改为折叠状态
      data.open = !data.open;
      this.$refs.leftTree.store.nodesMap[data.id].expanded = !data.open;
    },
    openParentBtn(data){
      data.open = !data.open;
      this.$refs.parentTree.store.nodesMap[data.id].expanded = !data.open;
    },
    /**
     * 树节点点击事件
     * @param data
     */
    handleNodeClick(data){
      this.departmentId = data.id;
      this.search(this.departmentId);
    },
    async search(departmentId, pageNo=1, pageSize=10){
      this.searchModel.pageNo = pageNo;
      this.searchModel.pageSize = pageSize;
      this.searchModel.departmentId = departmentId;
      console.log(departmentId)
      let res = await userApi.getUserList(this.searchModel);
      console.log(res)
      if (res.success) {
        console.log(res)
        this.userList = res.data.records;
        this.total = res.data.total;
      }
    },
    resetValue(){
      this.searchModel = {};
      this.search(this.departmentId)
    },
    openAddWindow(){
      this.$resetForm("userForm",this.user);
      this.userDialog.title="新增部门";
      this.userDialog.visible=true;
    },
    parentClick(data){
      this.user.departmentId = data.id;
      this.user.departmentName= data.departmentName;
    },
    async selectDepartment(){
      let res = await departmentApi.getDepartmentList(null);
      if (res.success) {
        this.parentList = res.data
      }
      this.parentDialog.visible = true;
    },
    handleEdit(row){
      this.userDialog.title  = "编辑用户";
      this.userDialog.visible  = true;
      this.$objCopy(row, this.user);
    },
    /**
     * 删除角色
     * @param row
     */
    async handleDelete(row){
      let confirm =await this.$myConfirm("确定要删除该数据吗?");
      if (confirm){
        let params = {id:row.id}
        let res = await userApi.deleteUser(params)
        if (res.success) {
          this.$message.success(res.message);
          await this.search(this.departmentId);
        } else {
          this.$message.error(res.message);
        }
      }
    },
    async assignRole(row){
      this.selectIds = [];
      this.selectedUserId = row.id;
      this.assignDialog.visible=true;
      this.assignDialog.title=`给【${row.realName}】分配角色`;
    //  调用查询角色列表的方法
      await this.getAssignRoleList();

      let params = {userId: row.id}
      let res = await userApi.getRoleByUserId(params)
      if (res.success && res.data){
        this.selectIds = res.data;
        this.selectIds.forEach((key) => {
          this.assignRoleList.forEach((item) =>{
            if (key === item.id){
              this.$refs.assignRoleTable.toggleRowSelection(item, true);
            }
          });
        })
      }
    },
    /**
     * 查询当前登陆用户所有的角色信息
     * @param pageNo
     * @param pageSize
     * @returns {Promise<void>}
     */
    async getAssignRoleList(pageNo=1, pageSize=10){
      this.roleVo.userId = this.$store.getters.userId;
      this.roleVo.pageNo = pageNo;
      this.roleVo.pageSize = pageSize;
      let res = await userApi.getAssignRoleList(this.roleVo);
      if (res.success){
        this.assignRoleList = res.data.records;
        this.roleVo.total= res.data.total;
      }
    },

    handleSelectionChange(rows){
      let roleIds = [];
      for (let i = 0; i < rows.length; i++) {
        roleIds.push(rows[i].id)
      }
      this.selectIds = roleIds;
    },
    assignSizeChange(size){
      this.roleVo.pageSize = size;
      this.getAssignRoleList(this.roleVo.pageNo, size);
    },
    assignCurrentChange(page){
      this.roleVo.pageNo = page;
      this.getAssignRoleList(page, this.roleVo.pageSize)
    },
    onAssignClose(){
      this.assignDialog.visible=false;
    },
    async onAssignConfirm() {
      if (this.selectIds.length === 0){
        this.$message.warning("请选择要分配的角色");
        return;
      }
      let params = {
        userId: this.selectedUserId,
        roleIds: this.selectIds,
      };
      let res = await userApi.assignRoleSave(params);
      if (res.success) {
        this.$message.success(res.message);
        this.assignDialog.visible= false;
      }else {
      this.$message.error(res.message);
      }
    },
    onClose(){
      this.userDialog.visible=false;
    },
    onConfirm() {
      this.$refs.userForm.validate(async (valid) => {
        if (valid) {
          let res = null;
          if (this.user.id === "") {
            res = await userApi.addUser(this.user)
          }else {
            res = await userApi.updateUser(this.user)
          }
          if (res.success) {
            this.$message.success(res.message);
            await this.search(this.departmentId);
            this.userDialog.visible= false;
          }
        }
      })
    },
    onParentClose(){
      this.parentDialog.visible=false;
      this.user.departmentName = "";
    },
    onParentConfirm() {
      this.parentDialog.visible=false;
    },

    /**
     * 当每页显示数量发生变化时触发
     */
    handleSizeChange(size){
      this.pageSize = size;
      this.search(this.departmentId, this.pageNo, size)
    },
    /**
     * 当页码发生变化时触发
     */
    handleCurrentChange(page){
      this.pageNo =page;
      this.search(this.departmentId, page, this.pageSize)
    },
  }
}
</script>
<style lang="scss" scoped>
::v-deep .el-tree{
  .el-tree-node {
    position: relative;
    padding-left: 10px;
  }
  .el-tree-node__children{
    padding-left: 20px;
    .el-tree-node :last-child:before{
      height: 40px;
    }
    .el-tree > .el-tree-node:before{
      border-left: none;
    }
    .el-tree > .el-tree-node:after{
      border-top: none;
    }
    .el-tree-node:before,
    .el-tree-node:after{
      content: "";
      left: -4px;
      position: absolute;
      right: auto;
      border-width: 1px;
    }
    .tree :first-child .el-tree-node:before{
      border-left: none;
    }
    .el-tree-node:before{
      border-left: 1px dotted #d9d9d9;
      height: 20px;
      top: -25px;
      width: 1px;
    }
    .el-tree-node:after{
      border-left: 1px dotted #d9d9d9;
      height: 20px;
      top: 14px;
      width: 24px;
    }
    .el-tree-node__expand-icon.is-leaf{
      width: 8px;
    }
    .el-tree-node__content > .el-tree-node__expand-icon{
      display: none;
    }
    .el-tree-node__content {
      line-height: 30px;
      height: 30px;
      padding-left: 10px !important;
    }
  }
}

::v-deep .el-tree > div {
  &::before{
    display: none;
  }
  &::after{
    display: none;
  }
}
</style>
