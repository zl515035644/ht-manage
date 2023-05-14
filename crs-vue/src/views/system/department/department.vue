<template>
<el-main>
<!--  查询条件区域 -->
  <el-form ref="searchForm" label-width="80px" :inline="true" size="small">
    <el-form-item>
      <el-input v-model="searchModel.departmentName" placeholder="请输入部门名称" />
    </el-form-item>
    <el-form-item>
      <el-button type="primary" icon="el-icon-search" @click="search()">查询</el-button>
      <el-button icon="el-icon-refresh-right">重置</el-button>
      <el-button icon="el-icon-plus" type="success" @click="openAddWindow()">新增</el-button>
    </el-form-item>
  </el-form>
  <el-table
    :data="tableData"
    border
    stripe
    style="width: 100%;margin-bottom: 20px;"
    row-key="id"
    default-expand-all
    :tree-props="{children: 'children'}">
    <el-table-column prop="departmentName" label="部门名称" />
    <el-table-column prop="phone" label="所属部门部门电话" />
    <el-table-column prop="address" label="部门地址" />
    <el-table-column prop="parentName" label="所属部门名称" />
    <el-table-column label="操作" width="200" align="center" >
      <template slot-scope="scope">
        <el-button icon="el-icon-edit-outline" type="primary" size="mini" @click="handleEdit(scope.row)">编辑</el-button>
        <el-button icon="el-icon-delete-solid" type="danger" size="mini" @click="handleDelete(scope.row)">删除</el-button>
      </template>
    </el-table-column>
  </el-table>
  <!-- 添加或修改窗口 -->
  <system-dialog
    :title="deptDialog.title"
    :visible="deptDialog.visible"
    :width="deptDialog.width"
    :height="deptDialog.height"
    @onClose="onClose()"
    @onConfirm="onConfirm()"
  >
    <div slot="content">
      <el-form :model="dept" ref="deptForm" :rules="rules" label-width="80px" :inline="true" size="small">
        <el-form-item label="所属部门" prop="parentName">
          <el-input v-model="dept.parentName" :readonly="true" @click.native="openSelectDeptWindow()" ></el-input>
        </el-form-item>
        <el-form-item label="部门名称" prop="departmentName">
          <el-input v-model="dept.departmentName"></el-input>
        </el-form-item>
        <el-form-item label="部门电话">
          <el-input v-model="dept.phone"></el-input>
        </el-form-item>
        <el-form-item label="部门地址">
          <el-input v-model="dept.address"></el-input>
        </el-form-item>
        <el-form-item label="序号">
          <el-input v-model="dept.orderNum"></el-input>
        </el-form-item>

      </el-form>
    </div>

  </system-dialog>
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
        :data="treeList"
        node-key="id"
        :props="defaultProps"
        empty-text="暂无数据"
        :highlight-current="true"
        :default-expand-all="true"
        :expand-on-click-node="false"
        @node-click="handleNodeClick">
        <div class="custom-tree-node" slot-scope="{node, data}">
          <!-- 判断当前节点是否有子节点-->
          <span v-if="data.children.length === 0" >
            <i class="el-icon-document"></i>
          </span>
          <span v-else @click="changeIcon(data)">
            <svg-icon v-if="data.open" icon-class="el-icon-plus"></svg-icon>
            <svg-icon v-else icon-class="el-icon-minus"></svg-icon>
          </span>
          <span style="margin-left: 3px" >{{node.label}}</span>
        </div>
      </el-tree>
    </div>
  </system-dialog>
</el-main>
</template>

<script>
import departmentApi from '@/api/department'
import SystemDialog from "@/components/system/SystemDialog";
import resetForm from "@/utils/resetForm";
import myConfirm from "@/utils/myConfirm";
export default {
  name: "department",
  components:{
    SystemDialog
  },
  data(){
    return{
      searchModel:{
        departmentName: "",
      },
      tableData:[],
      deptDialog:{
        title: "",
        visible: false,
        width: 580,
        height: 170,
      },
      parentDialog:{
        title: "选择所属部门",
        visible: false,
        width: 300,
        height: 400,
      },
      dept: {
        id: "",
        pid:"",
        departmentName: "",
        parentName: "",
        phone:"",
        address: "",
        orderNum:""
      },
      rules: {
        parentName: [{ required: true, message: '请选择所属部门', trigger: 'change' }],
        departmentName: [{ required: true, message: '请输入部门名称', trigger: 'blur' }],

      },
      treeList: [],
      defaultProps: {
        children: "children",
        label: "departmentName"
      }
    };
  },
  created() {
    this.search();
  },
  methods: {
    async search(){
      let res = await departmentApi.getDepartmentList(this.searchModel);
      if (res.success){
        this.tableData  = res.data;
      }
    },
    openAddWindow(){
      this.$resetForm("deptForm",this.dept);
      this.deptDialog.title="新增部门";
      this.deptDialog.visible=true;
    },
    onClose(){
      this.deptDialog.visible=false;
    },
    onConfirm() {
      this.$refs.deptForm.validate(async (valid) => {
        if (valid) {
          let res =null;
          if (this.dept.id === ""){
            res = await departmentApi.addDept(this.dept);
          }else {
            res = await departmentApi.updateDept(this.dept);
          }

          if (res.success) {
            this.$message.success(res.message);
            await this.search();
            this.deptDialog.visible = false;
          } else {
            this.$message.error(res.message);
          }
        }
      })
    },
    async openSelectDeptWindow(){
      this.parentDialog.visible=true;
      let res = await departmentApi.getParentTreeList();
      if (res.success){
        this.treeList  = res.data;
      }
    },
    changeIcon(data) {
      data.open = !data.open;
      this.$refs.parentTree.store.nodesMap[data.id].expanded = !data.open;
    },
    handleNodeClick(data){
      this.dept.pid = data.id;
      this.dept.parentName= data.label;
    },
    onParentClose(){
      this.parentDialog.visible=false;
    },
    onParentConfirm() {
      this.parentDialog.visible=false;
    },
    handleEdit(row) {
      this.$objCopy(row, this.dept);
      this.deptDialog.title = "编辑部门";
      this.deptDialog.visible = true;
    },
    async handleDelete(row) {
      let result = await departmentApi.checkDepartment({id:row.id});
      if (!result.success) {
        this.$message.warning(result.message)
      }else {
        let confirm =await this.$myConfirm("确定要删除吗?");
        if (confirm){
          let res = await departmentApi.deleteById({id:row.id})
          if (res.success) {
            this.$message.success(res.message);
            await this.search();
          } else {
            this.$message.error(res.message);
          }
        }
      }
    }
  }
}
</script>

<style scoped>

</style>
