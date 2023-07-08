import http from '@/utils/request'

/**
 * 查询部门列表
 * @param params
 * @returns
 */
export default {
  async getDepartmentList(params){
    console.log(params + "这是前端getDepartmentList传过来的数据")
    return http.get("/api/department/List", params);
  },
  async getParentTreeList(){
    return http.get("/api/department/parent/List");
  },
  async addDept(params){
    return http.post("/api/department/add",params);
  },
  async updateDept(params){
    return http.put("/api/department/update",params);
  },
  async checkDepartment(params) {
    console.log(params)
    return http.getRestApi("/api/department/check", params)
  },
  async deleteById(params) {
    return http.delete("/api/department/delete", params)
  }
}
