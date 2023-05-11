<template>
  <el-main>
    <el-form :model="searchModel" ref="searchForm" label-width="80px" :inline="true" size="small">
      <el-form-item>
        <el-input v-model="searchModel.roleName" placeholder="请输入角色名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="search(pageNo,pageSize)">查询</el-button>
        <el-button icon="el-icon-refresh-right"@click="resetValue()">重置</el-button>
        <el-button icon="el-icon-plus" type="success">新增</el-button>
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
  </el-main>
</template>

<script>
import {getRoles} from "@/api/role";

export default {
  name:"roleList",
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
    };
  },
  created() {
    console.log(this.$store.getters.userId)
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
      console.log(size)
      this.pageSize = size;
      this.search(this.pageNo, size)
    },
    /**
     * 当页码发生变化时触发
     */
    handleCurrentChange(page){
      console.log(page)
      this.pageNo =page;
      this.search(page, this.pageSize)
    },
    /**
     * 修改角色
     * @param row
     */
    handleEdit(row){

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
