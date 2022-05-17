#!/usr/bin/env node
import 'source-map-support/register';
import { App } from 'aws-cdk-lib';
import { noSqlDemoStack } from '../lib/SummitParisStack';

const app = new App();
new noSqlDemoStack(app, 'noSqlDemoStack', {});
