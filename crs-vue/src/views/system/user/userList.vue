<template>

    <el-container :style="{height: containerHeight + 'px'}">
      <!-- 左侧菜单树 -->
      <el-aside style="padding: 10px 0px 0px 0px; background: #fff; border-right: #dfe6ec" width="220px">
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
    </el-container>
</template>

<script>

import departmentApi from '@/api/department'

export default {
  name: "userList",
  data() {
    return{
          containerHeight: 0,
          deptList: [],
          defaultProps: {
            children: 'children',
            label: 'departmentName',
          },
    };
  },
  created() {
    this.getDeptList();
  },
  mounted() {
    this.$nextTick(()=>{
      this.containerHeight = window.innerHeight-85;
    })
  },
  methods:{
    async getDeptList(){
      let res = await departmentApi.getDepartmentList(null);
      if (res.success) {
        this.deptList = res.data;
      }
    },
    changeIcon(data) {
      data.open = !data.open;
      this.$refs.leftTree.store.nodesMap[data.id].expanded = !data.open;
    },
    handleNodeClick(data){

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
