<template>
  <el-main>
    <el-form :model="searchModel" ref="searchForm" label-width="80px" :inline="true" size="small">
      <el-form-item>
        <el-input v-model="searchModel.roleName" placeholder="请输入角色名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="search(pageNo,pageSize)">查询</el-button>
        <el-button icon="el-icon-refresh-right"@click="resetValue()">重置</el-button>
        <el-button icon="el-icon-plus" type="success" @click="openAddWindow()">新增</el-button>
      </el-form-item>
    </el-form>
    <el-table
      :data="roleList"
      :height="tableHeight"
      border
      stripe
      style="width: 100%;margin-bottom: 20px;">
      <el-table-column prop="id" label="角色编号" width="100" align="center"/>
      <el-table-column prop="roleCode" label="角色编码" width="100" align="center"/>
      <el-table-column prop="roleName" label="角色名称" />
      <el-table-column prop="remark" label="角色备注" />
      <el-table-column label="操作" width="290" align="center" >
        <template slot-scope="scope">
          <el-button icon="el-icon-edit" type="primary" size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button icon="el-icon-delete" type="danger" size="small" @click="handleDelete(scope.row)">删除</el-button>
          <el-button icon="el-icon-setting" type="primary"size="small" @click="assignRole(scope.row)">分配权限</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="pageNo"
      :page-sizes="[10,15,20,25,30]"
      :page-size="10"
      layout="total, sizes, prev, pager, next, jumper"
      :total="total">
    </el-pagination>
    <system-dialog
      :title = "roleDialog.title"
      :visible = "roleDialog.visible"
      :width = "roleDialog.width"
      :height = "roleDialog.height"
      @onClose = "onClose"
      @onConfirm = "onConfirm"
      >
      <div slot="content">
        <el-form
          :model = "role"
          ref="roleForm"
          :rules = "rules"
          label-width="80px"
          :inline = "false"
          size="small"
          >
          <el-form-item label="角色编码" prop="roleCode">
            <el-input v-model="role.roleCode"></el-input>
          </el-form-item>
          <el-form-item label="角色名称" prop="roleName">
            <el-input v-model="role.roleName"></el-input>
          </el-form-item>
          <el-form-item label="角色描述" prop="remark">
            <el-input type="textarea" v-model="role.remark" :rows="5"></el-input>
          </el-form-item>
        </el-form>
      </div>
    </system-dialog>
  </el-main>
</template>

<script>
import {getRoles, addRole, updateRole} from "@/api/role";
import SystemDialog from "@/components/system/SystemDialog";
export default {
  name:"roleList",
  components: {
    SystemDialog
  },
  data(){
    return{
      searchModel:{
        roleName: "",
        pageNo:1,
        pageSize:1,
        userId: this.$store.getters.userId,
      },
      roleList: [],
      tableHeight: 0,
      pageNo: 1,
      pageSize: 10,
      total: 0,
      rules: {
        roleCode:[{required:true, trigger: 'blur', message:"请输入角色编码"}],
        roleName:[{required:true, trigger: 'blur', message:"请输入角色名称"}]
      },
      roleDialog: {
        title:'',
        visible:false,
        height:230,
        width:500
      },
      role: {
        id:"",
        roleCode:'',
        roleName:'',
        remark:'',
        createUser:this.$store.getters.userId
      }
    };
  },
  created() {
    this.search();
  },

  mounted() {
    this.$nextTick(()=>{
      this.tableHeight =window.innerHeight-230;
    })
  },
  methods:{
    async search(pageNo=1, pageSize = 10){
      this.searchModel.pageNo = pageNo;
      this.searchModel.pageSize = pageSize;
      let res = await getRoles(this.searchModel);
      if (res.success) {
       this.roleList = res.data.records;
       this.total=res.data.total;
      }
    },
    resetValue(){
      //清空数据
      this.searchModel.roleName = null;
      this.search(1,10)
    },
    /**
     * 当每页显示数量发生变化时触发
     */
    handleSizeChange(size){
      this.pageSize = size;
      this.search(this.pageNo, size)
    },
    /**
     * 当页码发生变化时触发
     */
    handleCurrentChange(page){
      this.pageNo =page;
      this.search(page, this.pageSize)
    },
    openAddWindow(){
      this.$resetForm("roleForm", this.role);
      this.roleDialog.title="新增角色";
      this.roleDialog.visible = true;
    },
    /**
     * 关闭取消按钮点击事件
     */
    onClose() {
      this.roleDialog.visible = false;
    },
    /**
     * 确认按钮点击事件，
     */
    onConfirm() {
      this.$refs.roleForm.validate(async (valid) => {
        if (valid) {
          let res = null;
          if (this.role.id === ""){
            res = await addRole(this.role);
          }else {
            res = await updateRole(this.role);
          }
          if (res.success) {
            this.$message.success(res.message);
            await this.search();
            this.roleDialog.visible = false;
          } else {
            this.$message.error(res.message);
          }
        }
      })
    },
    /**
     * 修改角色
     * @param row
     */
    handleEdit(row){
      this.$objCopy(row, this.role);
      this.roleDialog.title = "修改部门";
      this.roleDialog.visible = true;
    },
    /**
     * 删除角色
     * @param row
     */
    handleDelete(row){

    },
    /**
     * 分配权限
     * @param row
     */
    assignRole(row){

    },

  },
}
</script>

<style scoped>

</style>
