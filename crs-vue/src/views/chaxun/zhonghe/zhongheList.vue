<template>

<div>

<el-container>

  <el-main style="height: 100%">
    <el-form :inline="true" :model="formInline" class="demo-form-inline"style="height: 5%">
      <el-form-item label="请输入户主姓名" style="margin:5px 5px 5px 0px">
        <el-input v-model="formInline.basicIdentityId" placeholder="152323196711072717" style="width: 260px"></el-input>
      </el-form-item>
      <el-form-item style="margin:5px 80px 5px 5px">
        <el-button type="primary" @click="search()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-descriptions  title="户主信息"  style="height: 30%" >
      <el-descriptions-item label="户编号"></el-descriptions-item>
      <el-descriptions-item label="户主姓名">{{this.basicHouseholdName}}</el-descriptions-item>
      <el-descriptions-item label="身份证号码"></el-descriptions-item>
      <el-descriptions-item label="银行卡号"></el-descriptions-item>
      <el-descriptions-item label="联系电话"></el-descriptions-item>
      <el-descriptions-item label="所在小组"></el-descriptions-item>
      <el-descriptions-item label="出生日期">1990-12-26</el-descriptions-item>
      <el-descriptions-item label="年龄">18</el-descriptions-item>
      <el-descriptions-item label="民族">蒙古族</el-descriptions-item>
      <el-descriptions-item label="学历">大学本科</el-descriptions-item>
      <el-descriptions-item label="性别">男</el-descriptions-item>
      <el-descriptions-item label="家庭人口">3</el-descriptions-item>
      <el-descriptions-item label="住房面积"></el-descriptions-item>
      <el-descriptions-item label="确权面积"></el-descriptions-item>
      <el-descriptions-item label="转移性收入(最新)">4356.68</el-descriptions-item>
      <el-descriptions-item label="户类别">一般户</el-descriptions-item>
    </el-descriptions>

    <el-tabs
      v-model="activeName"
      type="card"
      @tab-click="handleClick"
      style="height: 65%">
      <el-tab-pane label="家庭成员" name="first">
        <el-table
          :data="informationList"
          max-height="100%"
          border
          :header-cell-style="{'text-align':'center'}"
          style="width: 100%">
          <el-table-column prop="basicMemberId" label="成员编号" ></el-table-column>
          <el-table-column prop="basicMemberName" label="成员姓名" ></el-table-column>
          <el-table-column prop="basicRelation" label="与户主关系" ></el-table-column>
          <el-table-column prop="basicIdentityId" label="身份证号码" width="290"></el-table-column>
          <el-table-column prop="basicTelephone" label="联系电话" ></el-table-column>
          <el-table-column prop="basicAge" label="年龄" ></el-table-column>
          <el-table-column prop="basicNation" label="民族" ></el-table-column>
          <el-table-column align="center" label="操作">
            <template slot-scope="scope">
              <el-button icon="el-icon-edit" type="primary" size="mini"
                         @click="handleEdit(scope.row)">修改</el-button>
              <el-button icon="el-icon-delete" type="danger" size="mini"
                         @click="handleDelete(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="耕地补贴" name="second">耕地补贴</el-tab-pane>
      <el-tab-pane label="农业保险" name="fourth">农业保险</el-tab-pane>
      <el-tab-pane label="生产者补贴" name="five">生产者补贴</el-tab-pane>
      <el-tab-pane label="一卡通收入" name="third">一卡通收入</el-tab-pane>
    </el-tabs>



  </el-main>
</el-container>

</div>
</template>

<script>
import informationApi from "@/api/information";

export default {
  name: "zhongheList",
  data() {
    return {
      formInline: {

        basicIdentityId: "",

      },
      household: [],
      informationList: [],
      basicHouseholdName:"",
      basicIdentityId:"",
      activeName: 'first',
    }

  },
  created(){

    this.search()
  },
  methods: {
    async search() {
      if (this.basicIdentityId != null){
        let res = await informationApi.InformationById(this.formInline);
        if (res.success) {
          this.informationList = res.data
          this.basicHouseholdName = res.data[0]?.household?.basicHouseholdName;
        }
      }
    },
    handleClick(tab, event) {
      console.log(tab, event);
    },
    handleEdit(){

    },
    handleDelete(){

    },
  }
}
</script>
<style scoped>
.demo-form-inline {
  text-align: center;
  height: 45px;

}
div.el-form-item.el-form-item--medium{
  height: 20px;
}
el-form{
  width: 260px;
}

</style>
