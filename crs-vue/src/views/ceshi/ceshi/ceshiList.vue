<template>
  <el-container :style="{height: containerHeight + 'px'}">
    <!-- 左侧菜单树 -->
    <el-aside style="padding: 10px 0 0 0; background: #fff; border-right: #dfe6ec" width="220px">
      <el-tree
        style="font-size: 14px"
        ref="leftVillageTree"
        :data="villageList"
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
            <span @click.stop="changeIcon(data)">
                <svg-icon v-if="data.open" icon-class="add-s"/>
                <svg-icon v-else icon-class="sub-s"/>
              </span>
            <span style="margin-left: 3px">{{node.label}}</span>
          </div>
        </div>
      </el-tree>
    </el-aside>
  </el-container>
</template>

<script>
import villageApi from "@/api/village";

export default {
  name: "ceshiList",
  components: {
  },
  data() {
    return {
      containerHeight: 0,
      villageList: [],
      defaultProps: {
        // children: 'children',
        label: 'villageName',
      },
    }
  },
  created(){
    this.getVillageList();
  },
  mounted() {
    this.$nextTick(()=>{
      this.containerHeight = window.innerHeight-85;
    })
  },
  methods: {
    async getVillageList(){
      //查询村列表
      let res = await villageApi.getVillageList(null)
      if (res.success) {
        this.villageList = res.data;
        // console.log(res)
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
    },

  }
}
</script>

<style scoped>

</style>
