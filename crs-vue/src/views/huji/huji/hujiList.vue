<template>
<div>
  <el-container :style="{height: containerHeight + 'px'}">
    <!-- 户籍成员信息 -->
    <el-main>
      <el-form ref="searchForm" :model="searchModel" label-width="80px" :inline="true" size="small">
        <el-form-item>
          <el-input v-model="searchModel.basicMemberName" placeholder="请输入姓名"/>
        </el-form-item>
        <el-form-item>
          <el-input v-model="searchModel.basicIdentityId" placeholder="请输入身份证号码"/>
        </el-form-item>
        <el-form-item>
          <el-button icon="el-icon-search" type="primary"
                     @click="search(pageNo, pageSize)">查询</el-button>
          <el-button icon="el-icon-delete" @click="resetValue()">重置</el-button>
          <el-button icon="el-icon-plus" type="primary"
                     @click="openAddWindow()">新增</el-button>
        </el-form-item>
      </el-form>
      <el-table
        :data="informationList"
        :height="tableHeight"
        border
        stripe
        style="width: 100%; margin-bottom: 10px">
        <el-table-column  prop="basicMemberId" label="成员编号" ></el-table-column>
        <el-table-column prop="basicMemberName" label="成员姓名" ></el-table-column>
        <el-table-column prop="basicRelation" label="与户主关系" ></el-table-column>
        <el-table-column prop="basicIdentityId" label="身份证号码" width="290"></el-table-column>
        <el-table-column prop="basicTelephone" label="联系电话" ></el-table-column>
        <el-table-column prop="basicAge" label="年龄" ></el-table-column>
        <el-table-column prop="basicBirthday" label="出生日期" ></el-table-column>
        <el-table-column prop="basicNation" label="民族" ></el-table-column>
        <el-table-column align="basicTelephone" label="操作" width="180">
          <template slot-scope="scope">
            <el-button icon="el-icon-edit" type="primary" size="mini"
                       @click="handleEdit(scope.row)">修改</el-button>
            <el-button icon="el-icon-delete" type="danger" size="mini"
                       @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页  -->
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
</div>
</template>

<script>
import SystemDialog from "@/components/system/SystemDialog";
import hujiApi from "@/api/huji";

export default {
  name: "hujiList",
  components: {
    SystemDialog
  },
  data() {
    return{
      containerHeight: 0,
      informationList: [],
      tableHeight: 0,
      pageNo:1,
      pageSize:10,
      total: null,
      basicMemberId:"",
      searchModel:{
        basicIdentityId:"",
        basicMemberName:"",
        pageNo:1,
        pageSize:10,
      },
    }
  },
  created() {
    this.search()
  },
  mounted() {
    this.$nextTick(()=>{
      this.containerHeight = window.innerHeight-85;
      this.tableHeight = window.innerHeight-220;
      this.assignHeight = window.innerHeight-350;
    })
  },
  methods: {
    async search(pageNo = 1, pageSize = 10) {
      this.searchModel.pageNo = pageNo;
      this.searchModel.pageSize = pageSize;

      let res = await hujiApi.gethujiListAll(this.searchModel);

      if (res.success) {
        console.log(res)
        this.informationList = res.data.records;
        this.total = res.data.total;
      }
    },
    resetValue() {
      // this.searchModel = {};
      // this.search(this.basicHouseholdId)
    },
    openAddWindow() {

    },
    handleEdit(row) {

    },
    /**
     * 删除角色
     * @param row
     */
    async handleDelete(row) {

    },
    /**
     * 当每页显示数量发生变化时触发
     */
    handleSizeChange(size){
      // this.pageSize = size;
      // this.search(this.basicHouseholdId, this.pageNo, size)
    },
    /**
     * 当页码发生变化时触发
     */
    handleCurrentChange(page){
      // this.pageNo =page;
      // this.search(this.basicHouseholdId, page, this.pageSize)
    },
  }
}
</script>

<style scoped>

</style>
