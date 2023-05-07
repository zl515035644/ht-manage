<template>
    <el-main>
      <!--  查询条件区域 -->
      <el-button icon="el-icon-plus" type="success" @click="openAddWindow()" size="small">新增</el-button>
      <el-table
        :data="menuList"
        :height="tableHeight"
        style="width: 100%; margin-top: 20px"
        row-key="id"
        border
        default-expand-all
        :tree-props="{ children: 'children'}"

      >
        <el-table-column prop="label" label="菜单名称" width="280px"></el-table-column>
        <el-table-column prop="type" label="菜单类型" align="center" width="120px">
          <template slot-scope="scope">
            <el-tag size="normal" v-if="scope.row.type === 0">目录</el-tag>
            <el-tag type="success" v-else-if="scope.row.type === 1">菜单</el-tag>
            <el-tag type="warning" v-else>按钮</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="icon" label="菜单图标" align="center"  width="120px">
          <template slot-scope="scope">
            <i :class="scope.row.icon" v-if="scope.row.icon.includes('el-icon')"></i>
            <svg-icon v-else :icon-class="scope.row.icon"></svg-icon>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="路由名称" width="280px"></el-table-column>
        <el-table-column prop="path" label="路由地址" width="280px"></el-table-column>
        <el-table-column prop="url" label="组件路径" width="320px"></el-table-column>
        <el-table-column label="操作" align="center" >
          <template slot-scope="scope">
            <el-button icon="el-icon-edit-outline" type="primary" size="mini" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button icon="el-icon-delete-solid" type="danger" size="mini" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 添加或修改窗口 -->
      <system-dialog
        :title="menuDialog.title"
        :visible="menuDialog.visible"
        :width="menuDialog.width"
        :height="menuDialog.height"
        @onClose="onClose()"
        @onConfirm="onConfirm()">
        <div slot="content">
          <el-form :model="menu" ref="menuForm" :rules="rules" label-width="80px" :inline="true" size="small">
            <el-col :span = "24">
              <el-form-item label="菜单类型" prop="type">
                <el-radio-group v-model="menu.type">
                  <el-radio :label="0">目录</el-radio>
                  <el-radio :label="1">菜单</el-radio>
                  <el-radio :label="2">按钮</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-form-item label="所属菜单" size="small" prop="parentName">
              <el-input v-model="menu.parentName" :readonly="true" @click.native="selectParentMenu()"></el-input>
            </el-form-item>
            <el-form-item label="菜单名称" size="small" prop="label">
              <el-input v-model="menu.label"></el-input>
            </el-form-item>
            <el-form-item label="菜单图标" size="small" >
              <el-input v-model="menu.icon"></el-input>
            </el-form-item>
            <el-form-item label="路由名称" size="small" prop="name" v-if="menu.type === 1">
              <el-input v-model="menu.name"></el-input>
            </el-form-item>
            <el-form-item label="路由地址" size="small" prop="path" v-if="menu.type !== 2">
              <el-input v-model="menu.path"></el-input>
            </el-form-item>
            <el-form-item label="组件路径" size="small" prop="url" v-if="menu.type === 1">
              <el-input v-model="menu.url"></el-input>
            </el-form-item>
            <el-form-item label="权限字段" size="small" prop="code">
              <el-input v-model="menu.code"></el-input>
            </el-form-item>
            <el-form-item label="菜单序号" size="small">
              <el-input v-model="menu.orderNum"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </system-dialog>
      <system-dialog
      :title="parentDialog.title"
      :width="parentDialog.width"
      :height="parentDialog.height"
      :visible="parentDialog.visible"
      @onClose="onParentClose()"
      @onConfirm="onParentConfirm()">
       <div slot="content">
         <el-tree
           style="font-size: 14px"
           ref="parentTree"
           :data="parentMenuList"
           node-key="id"
           :props="defaultProps"
           empty-text="暂无数据"
           :show-checkbox="false"
           default-expand-all
           :highlight-current="true"
           :expand-on-click-node="false"
           @node-click="handleNodeClick">
           <div class="customer-tree-node" slot-scope="{node, data}">
             <span v-if="data.children.length == 0">
               <i class="el-icon-document" style="color: #8c8c8c; font-size: 18px"/>
             </span>
             <span v-else @click.stop="changeIcon(data)">
               <svg-icon v-if="data.open" icon-class="add-s"/>
               <svg-icon v-else icon-class="sub-s"/>
             </span>
             <span style="margin-left: 3px">{{node.label}}</span>
           </div>
         </el-tree>
       </div>
      </system-dialog>

    </el-main>
</template>

<script>

import menuApi from "@/api/menu";
import SystemDialog from "@/components/system/SystemDialog.vue";
import departmentApi from "@/api/department";

export default {
  name: "menuList",
  components:{
    SystemDialog
  },
  data(){
    return{
      menuList: [],//数据列表
      tableHeight: 0,//表格高度
      menuDialog: {
        title:"新增窗口",
        visible: false,
        width: 630,
        height: 270
      },
      menu: {
        id:"",
        type: "",
        parentId:"",
        parentName:"",
        label:"",
        icon:"",
        name:"",
        path:"",
        url:"",
        code:"",
        orderNum:""
      },
      rules: {
        type: [{required: true, trigger: "change", message: "请输入菜单类型"}],
        parentName: [{required: true, trigger: "change", message: "请输入所属菜单"}],
        label: [{required: true, trigger: "blur", message: "请输入菜单名称"}],
        name: [{required: true, trigger: "blur", message: "请输入路由名称"}],
        path: [{required: true, trigger: "blur", message: "请输入路由路径"}],
        url: [{required: true, trigger: "blur", message: "请输入组件路径"}],
        code: [{required: true, trigger: "blur", message: "请输入权限字段"}]
      },
      parentDialog: {
        title:"新增窗口",
        visible: false,
        width: 630,
        height: 270
      },
      defaultProps: {
        children: "children",
        label: 'label'
      },
      parentMenuList: []//所属菜单列表
    };
  },
  created() {
    this.search();
  },
  mounted() {
    this.$nextTick(()=>{
      this.tableHeight =window.innerHeight-180;
    })
  },
  methods:{
    /**
     * 查询菜单列表
     * @returns {Promise<void>}
     */
    async search() {
      let res = await menuApi.getMenuList();
      if (res.success) {
        this.menuList = res.data;
      }
    },
    /**
     * 打开新增窗口
     */
    openAddWindow() {
      this.$resetForm("menuForm", this.menu)
      //设置窗口标题
      this.menuDialog.title = "新增菜单"
      this.menuDialog.visible = true;
    },
    handleEdit(row){
      this.$objCopy(row, this.menu);

      this.menuDialog.title = "编辑菜单";
      this.menuDialog.visible = true;
      // this.$nextTick(()=>{
      //   this.$refs["child"].userChooseIcon = row.icon
      // })
    },
    async handleDelete(row) {
      console.log("要删除的ID是：" + row.id);
      let result = await menuApi.checkPermission({id:row.id});
      console.log("程序到这里了")
      if (!result.success) {
        console.log("程序到这里了"+ result.success);
        this.$message.warning(result.message)
      }else {
        let confirm =await this.$myConfirm("确定要删除吗?");
        if (confirm){
          let res = await menuApi.deleteById({id:row.id})
          if (res.success) {
            this.$message.success(res.message);
            await this.search();
          } else {
            this.$message.error(res.message);
          }
        }
      }
    },
    /**
     * 关闭取消按钮点击事件
     */
    onClose() {
      this.menuDialog.visible = false;
    },
    /**
     * 确认按钮点击事件，
     */
    onConfirm() {
      this.$refs.menuForm.validate(async (valid) => {
        if (valid){
          let res = null;
          if (this.menu.id === ""){
            res = await menuApi.addMenu(this.menu);
          }else {
            res = await menuApi.updateMenu(this.menu);
          }
          if (res.success) {
            this.$message.success(res.message);
            await this.search();
            this.menuDialog.visible = false;
          }else {
            this.$message.error(res.message);
          }
        }
      })

    },
    /**
     * 选择所属菜单
     * @returns {Promise<void>}
     */
    async selectParentMenu(){
      this.parentDialog.visible=true;
      //发送查询请求
      let res = await menuApi.getParentMenuList();
      //判断是否成功
      if (res.success) {
        this.parentMenuList = res.data;
      }
    },
    /**
     * 关闭取消按钮点击事件
     */
    onParentClose() {
      console.log("关闭取消按钮点击事件")
      this.parentDialog.visible = false;
    },
    /**
     * 确认按钮点击事件，
     */
    onParentConfirm() {
      console.log("确认按钮点击事件，")
      this.$refs.menuForm.validate((valid) => {
        if (valid){
          this.parentDialog.visible = false;
        }
      })
    },
    changeIcon(data) {
      data.open = !data.open;
      this.$refs.parentTree.store.nodesMap[data.id].expanded = !data.open;
    },
    /**
     * 所属菜单节点点击事件
     * @param data
     */
    handleNodeClick(data) {
      this.menu.parentId = data.id;
      this.menu.parentName = data.label;
    }
  }
}
</script>

<style scoped>

</style>
