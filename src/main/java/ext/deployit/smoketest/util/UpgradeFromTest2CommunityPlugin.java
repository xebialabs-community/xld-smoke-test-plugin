/**
 * Copyright 2017 XEBIALABS
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package ext.deployit.smoketest.util;


import com.xebialabs.deployit.server.api.repository.RawRepository;
import com.xebialabs.deployit.server.api.upgrade.Upgrade;
import com.xebialabs.deployit.server.api.upgrade.UpgradeException;
import com.xebialabs.deployit.server.api.upgrade.Version;


public class UpgradeFromTest2CommunityPlugin extends Upgrade {
    @Override
    public boolean doUpgrade(final RawRepository repository) throws UpgradeException {

        repository.renameType("tests2.TestRunner", "smoketest.Runner");
        repository.renameType("tests2.HttpRequestTest", "smoketest.HttpRequestTest");
        repository.renameType("tests2.HttpRequestTest", "smoketest.HttpRequestTest");
        repository.renameType("tests2.ExecutedHttpRequestTest", "smoketest.ExecutedHttpRequestTest");
        repository.renameType("tests2.ExecutedHttpPostRequestTest", "smoketest.ExecutedHttpPostRequestTest");
        repository.renameType("tests2.ExecutedHttpPostFileRequestTest", "smoketest.ExecutedHttpPostRequestFileTest");

        return true;
    }

    @Override
    public Version upgradeVersion() {
        return Version.valueOf("deployit", "4.5.0");
    }
}
