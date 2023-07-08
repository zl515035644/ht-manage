<template>
  <el-container>
    <el-header><el-form :inline="true" :model="formInline" class="demo-form-inline" style="margin-top: 10px">
      <el-form-item label="省">
        <el-select v-model="formInline.province" placeholder="请选择省份" disabled>
          <el-option label="内蒙古自治区" value="innerMongolia"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="市">
        <el-select v-model="formInline.city" placeholder="请选择城市" disabled>
          <el-option label="通辽市" value="tongliao"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="县">
        <el-select v-model="formInline.counties" placeholder="请选择旗县" disabled>
          <el-option label="科左后旗" value="kzhq"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="镇">
        <el-select v-model="formInline.township" placeholder="请选择镇" disabled>
          <el-option label="查日苏镇" value="crsz"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="村">
        <el-select v-model="formInline.village" placeholder="请选择村">
          <el-option v-for="val in villageList" :key="val.formInline" :value="val.villageId" :label="val.villageName"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit(formInline.village)">查询</el-button>
      </el-form-item>
    </el-form></el-header>
    <el-container :style="{height: containerHeight + 'px'}">
      <el-aside style="padding: 10px 0 0 0; line-height: 0px; background: #fff; border-right: #dfe6ec" width="220px">
        <el-tree
          style="font-size: 14px"
          ref="leftVillageTree"
          :data="groupList"
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
              <!--            <span v-if="data.children.length === 0">-->
              <!--              <i class="el-icon-document"></i>-->
              <!--            </span>-->
              <span  @click.stop="changeIcon(data)">
              <svg-icon v-if="data.open" icon-class="add-s"/>
              <svg-icon v-else icon-class="sub-s"/>
            </span>
              <span style="margin-left: 3px">{{node.label}}</span>
            </div>
          </div>
        </el-tree>
      </el-aside>
      <el-main>
        <el-form ref="searchForm" :model="searchModel" label-width="80px" :inline="true" size="small">

            <el-form-item>
              <el-input v-model="searchModel.basicHouseholdName" placeholder="请输入用户名"/>
            </el-form-item>
            <el-form-item>
              <el-button icon="el-icon-search" type="primary"
                         @click="search(basicGroupId, pageNo, pageSize)">查询</el-button>
            </el-form-item>
        </el-form>

        <el-table
          :data="householdList" :height="tableHeight" border stripe
          style="width: 100%; margin-bottom: 10px">
          <el-table-column  prop="basicHouseholdId" label="户主编号" ></el-table-column>
          <el-table-column prop="basicHouseholdName" label="户主姓名" ></el-table-column>
          <el-table-column prop="basicExistingPopulation" label="家庭人口" ></el-table-column>
          <el-table-column prop="basicBankCard" label="银行卡号" ></el-table-column>
          <el-table-column prop="basicLandArea" label="土地面积" ></el-table-column>
          <el-table-column prop="basicHouseArea" label="住房面积" ></el-table-column>
          <el-table-column prop="basicGroupId" label="所在小组" ></el-table-column>

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

    </el-container>
  </el-container>
</template>

<script>

import villageApi from "@/api/village";
import groupApi from "@/api/group";
import householdApi from "@/api/household";

export default {
  name: "huzhuList",
  components: {
  },
  data() {
    return {
      containerHeight: 0,
      tableHeight: 0,
      villageList: [],
      villageName: "",
      groupList: [],
      groupId: "",
      villageId: '',
      groupName:'',
      householdList:[],
      basicGroupId:'',
      pageNo:1,
      pageSize:10,
      total: null,
      defaultProps: {
        // children: 'groupList',
        label: 'groupName',
      },
      formInline:{
        province: '内蒙古自治区',
        city: '通辽市',
        counties: '科尔沁左翼后旗',
        township: '查日苏镇',
        village: '',
        villageId: ''
      },
      searchModel:{
        basicHouseholdId: "",
        basicHouseholdName: "",
        basicExistingPopulation: "",
        basicLandArea: "",
        basicBankCard: "",
        basicHouseArea: "",
        basicGroupId: "",
        pageNo:1,
        pageSize:10,
      },
    }
  },
  created(){
    this.getVillageList();
  },

  mounted() {
    this.$nextTick(()=>{
      this.containerHeight = window.innerHeight-85;
      this.tableHeight = window.innerHeight-300;
    })
  },
  methods: {
    async getVillageList(){
      //查询村列表
      let res = await villageApi.getGroupListByVillageId(this.formInline)

      // let res = await villageApi.getVillageList(null)
      if (res.success) {
        this.villageList = res.data;
          this.$nextTick(() => {
            const firstNode = document.querySelector(".el-tree-node");
            firstNode.click();
          })
      }
    },
    changeIcon(data) {
      data.open = !data.open
      this.$refs.leftVillageTree.store.nodesMap[data.id].expanded = !data.open
    },
    handleNodeClick(data){
      this.basicGroupId = data.id;
      this.search(this.basicGroupId, 1, 10)

    },
    async search(basicGroupId, pageNo=1, pageSize=10){
      this.searchModel.pageNo = pageNo;
      this.searchModel.pageSize = pageSize;
      this.searchModel.basicGroupId = basicGroupId;
      let res = await householdApi.getHouseholdList(this.searchModel);

      if (res.success) {
        this.householdList = res.data.records;
        this.total = res.data.total;
      }
    },
    async onSubmit(villageId){
      this.formInline.villageId=villageId
        let res = await groupApi.getGroupList(this.formInline)
        if (res.success) {
          this.groupList = res.data;
          this.$nextTick(() => {
            const firstNode = document.querySelector(".el-tree-node");
            firstNode.click();

          })
      }
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

<style scoped>

</style>
