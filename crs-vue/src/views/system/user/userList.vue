<template>
  <div>用户管理</div>
<!--  <el-container :style="{height: containerHeight + 'px'}">-->
<!--    &lt;!&ndash; 左侧菜单树 &ndash;&gt;-->
<!--    <el-aside style="padding: 10px 0px 0px 0px; background: #fff; border-right: #dfe6ec" width="200px">-->
<!--      <el-tree-->
<!--        style="font-size: 14px"-->
<!--        ref="leftTree"-->
<!--        :data="deptList"-->
<!--        node-key="id"-->
<!--        :props="defaultProps"-->
<!--        default-expand-all-->
<!--        empty-text="暂无数据"-->
<!--        :show-checkbox="false"-->
<!--        :highlight-current="true"-->
<!--        :expand-on-click-node="false"-->
<!--        @node-click="handleNodeClick">-->
<!--        <div class="custom-tree-node" slot-scope="{node, data}">-->
<!--          <div>-->
<!--            <span v-if="data.children.length == 0">-->
<!--              <i class="el-icon-document"></i>-->
<!--            </span>-->
<!--            <span v-else @click.stop="openBtn(data)">-->
<!--              <svg-icon v-if="data.open" icon-class="add-s"/>-->
<!--              <svg-icon v-else icon-class="sub-s"/>-->
<!--            </span>-->
<!--            <span style="margin-left: 3px">{{node, label}}</span>-->
<!--          </div>-->
<!--        </div>-->
<!--      </el-tree>-->
<!--    </el-aside>-->
<!--    &lt;!&ndash; 右侧列表 &ndash;&gt;-->
<!--  </el-container>-->
</template>

<script>


export default {
  name: "userList",
  data() {
    return{
  //     containerHeight: 0,
  //     deptList: [],
  //     defaultProps: {
  //       children: "children",
  //       label: "departmentName",
  //     },
    };
  },
  // created() {
  // },
  // mounted() {
  //   this.$nextTick(()=>{
  //     this.containerHeight = window.innerHeight-85;
  //   })
  // },
  // methods:{
  //   async getDeptList(){
  //     let res = await departmentApi.getDepartmentList(null);
  //     if (res.success) {
  //       this.deptList = res.data;
  //     }
  //   },
  //   handleNodeClick(data) {
  //
  //   },
  //   openBtn(data){
  //     this.getDeptList();
  //   },
  // }
}
</script>

<style scoped>

</style>
