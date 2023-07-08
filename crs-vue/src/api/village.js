import http from '@/utils/request'

/**
 * 查询镇村列表
 * @param params
 * @returns
 */
export default {
  async getVillageList(params) {
    return http.get("/api/village/List", params);
  },
  async getGroupListByVillageId(params) {
    return http.get("/api/village/villageId", params);
  },

}
