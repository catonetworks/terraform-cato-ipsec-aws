# Changelog

## 0.0.1 (2024-11-01)

### Features
- Initial commit 

## 0.0.5 (2025-05-07)

### Features
- Added optional license resource and inputs used for commercial site deployments

## 0.0.6 (2025-05-12)

### Features
- Added conditional logic to create VPC if vpc_id is null

## 0.0.7 (2025-07-16)

### Features 
 - Add Site_location (v0.0.2) to dynamically generate site_location 
 - Version lock cato provider to 0.0.30 or greater 
 - Version lock terraform to 1.5 or greater 
 - Update ReadMe with more detail

## 0.1.0 (2025-07-16)

### Features
 - Added: 
   - Full Support for BGP 
   - HA Tunnels (2 Tunnels built to AWS for Redunancy)
   - Data Calls for Cato IP ID 
   - BGP Creation on Both Cato and AWS Side
   - Support for AWS Tags on Resources  

 - Fixed: 
   - Missing VPC Attachment for the VGW 

 - Updated: 
   - Updated Readme with additional detail around configuration of BGP 
   - Updated Outputs 
