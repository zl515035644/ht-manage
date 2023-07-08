<template>
  <el-main>
    <el-form :model="searchModel" ref="searchForm" label-width="80px" :inline="true" size="small">
      <el-form-item>
        <el-input v-model="searchModel.roleName" placeholder="请输入角色名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="search(pageNo,pageSize)">查询</el-button>
        <el-button icon="el-icon-refresh-right"@click="resetValue()">重置</el-button>
        <el-button icon="el-icon-plus" type="success"
                   @click="openAddWindow()">新增</el-button>
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
          <el-button icon="el-icon-edit" type="primary" size="small"
                     @click="handleEdit(scope.row)">编辑</el-button>
          <el-button icon="el-icon-delete" type="danger" size="small"
                     @click="handleDelete(scope.row)">删除</el-button>
          <el-button icon="el-icon-setting" type="primary"size="small"
                     @click="assignRole(scope.row)">分配权限</el-button>
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
    <system-dialog
      :title = "assignDialog.title"
      :visible = "assignDialog.visible"
      :width = "assignDialog.width"
      :height = "assignDialog.height"
      @onClose = "onAssignClose"
      @onConfirm = "onAssignConfirm"
    >
      <div slot="content">
        <el-tree
          ref="assignTree"
          :data="assignTreeData"
          node-key="id"
          :props="defaultProps"
          empty-text="暂无数据"
          :show-checkbox="true"
          :highlight-current="true"
          default-expand-all
        >
        </el-tree>
      </div>
    </system-dialog>
  </el-main>
</template>

<script>
import {getRoles, addRole, updateRole, checkRole, deleteRole, getAssignTree, saveRoleAssign} from "@/api/role";
import SystemDialog from "@/components/system/SystemDialog";
import leafUtils from "@/utils/leaf";
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
        height:450,
        width:300
      },
      roleId: "",
      assignTreeData: [],
      defaultProps: {
        children: "children",
        label: "label"
      },
      assignDialog: {
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
            await this.search(this.pageNo, this.pageSize);
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
    async handleDelete(row){
      let result = await checkRole({id:row.id});
      if (!result.success) {
        this.$message.warning(result.message)
      }else {
        let confirm =await this.$myConfirm("确定要删除该数据吗?");
        if (confirm){
          let res = await deleteRole({id:row.id})
          if (res.success) {
            this.$message.success(res.message);
            await this.search(this.pageNo, this.pageSize);
          } else {
            this.$message.error(res.message);
          }
        }
      }
    },
    /**
     * 分配权限
     * @param row
     */
    async assignRole(row){
    //  将roleId赋值
      this.roleId = row.id;
    //  构建查询参数
      let params = {
        roleId: row.id,
        userId: this.$store.getters.userId
      }
    //  发送查询分配权限菜单请求
      let res = await getAssignTree(params);
      if (res.success) {
      //  获取当前登陆用户所拥有的菜单权限
        console.log(res)
        let {permissionList} = res.data;
      //  获取当前登陆用户被分配角色已经拥有的菜单权限
        let {checkList} = res.data;
        //判断当前菜单是否是最后一级
        let {setLeaf} = leafUtils();
        //设置权限列表
        let newPermissionList = setLeaf(permissionList);
      //  设置树节点数据
        this.assignTreeData = newPermissionList;
      //  将回调延迟到下一次DOM更新循环之后执行，在修改数据之后立即调用该方法，然后等等DOM更新
        this.$nextTick(()=>{
          let nodes = this.$refs.assignTree.children;
        //  设置子节点
          this.setChild(nodes,checkList);
        })
      }
    //设置权限标题
      this.assignDialog.title=`给【${row.roleName}】分配权限`;
    //  显示窗口
      this.assignDialog.visible=true;
    },
    setChild(childNodes, checkList){
      if (childNodes && childNodes.length>0) {
        for (let i=0; i<childNodes.label; i++){
        //  根据data或key获取数组件中的node节点
          let node = this.$refs.assignTree.getNode(childNodes[i]);
          if (checkList && checkList.length>0){
            for (let j=0; j<checkList.length; j++){
              if (childNodes[i].id === checkList[j]){
                if (childNodes[i].open){
                  this.$refs.assignTree.setChecked(node, true);
                  break;
                }
              }
            }
          }
          if (childNodes[i].children) {
            this.setChild(childNodes[i].children, checkList)
          }
        }
      }
    },
    /**
     * 关闭取消按钮点击事件
     */
    onAssignClose() {
      this.assignDialog.visible = false;
    },
    /**
     * 确认按钮点击事件，
     */
    async onAssignConfirm() {
      let ids = this.$refs.assignTree.getCheckedKeys();
      //获取选中的父节点的ID
      let pids = this.$refs.assignTree.getHalfCheckedKeys();
      console.log(ids+"-----"+pids)

      let listId = ids.concat(pids);

      let params = {
        roleId:this.roleId,
        list: listId,// 选中的节点ID列表
      }
      let res = await saveRoleAssign(params);
      if (res.success) {
        this.assignDialog.visible = false;
        this.$message.success(res.message);
      } else {
        this.$message.error(res.message);
      }
    }
  },
}
</script>

<style scoped>

</style>
